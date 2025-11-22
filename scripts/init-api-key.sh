#!/bin/sh
set -e

# Skip initialization if GRIST_API_KEY is not set
if [ -z "$GRIST_API_KEY" ]; then
    echo "GRIST_API_KEY not set, skipping API key initialization"
    exit 0
fi

echo "Waiting for Grist to be ready..."

# Wait for Grist to be ready (poll /status endpoint)
until curl -sf http://localhost:8484/status > /dev/null 2>&1; do
    echo "Grist not ready yet, waiting..."
    sleep 2
done

echo "Grist is ready, configuring API key..."

# Set NODE_PATH for Grist modules
export NODE_PATH=/grist/_build:/grist/_build/stubs:/grist/_build/ext

# Run Node.js script to set API key
node -e "
import { HomeDBManager } from 'file:///grist/_build/app/gen-server/lib/homedb/HomeDBManager.js';

(async () => {
    try {
        const dbManager = new HomeDBManager();
        await dbManager.connect();
        await dbManager.initializeSpecialIds();

        const user = await dbManager.getUserByLogin('${GRIST_DEFAULT_EMAIL}');
        if (!user) {
            console.error('User not found: ${GRIST_DEFAULT_EMAIL}');
            process.exit(1);
        }

        user.apiKey = '${GRIST_API_KEY}';
        await user.save();
        await dbManager.getOrg({ userId: user.id }, null);

        console.log('API key configured successfully for user: ${GRIST_DEFAULT_EMAIL}');
    } catch (error) {
        console.error('Error configuring API key:', error);
        process.exit(1);
    }
})();
"

echo "API key initialization complete"
