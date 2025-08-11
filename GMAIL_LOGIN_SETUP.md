# Gmail Login Setup Guide

This guide explains how to set up Gmail authentication for the Finviz Scanner frontend.

## Prerequisites

You need a Google Cloud account to create OAuth credentials.

## Step 1: Create Google OAuth Credentials

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to "APIs & Services" > "Credentials"
4. Click "Create Credentials" > "OAuth 2.0 Client IDs"
5. Configure the OAuth consent screen if not already done
6. Set the application type to "Web application"
7. Add your domain to "Authorized JavaScript origins":
   - For development: `http://localhost`, `http://localhost:3000`, `http://127.0.0.1`
   - For production: `https://your-domain.com`
8. Add redirect URIs (optional, mainly for consent screen):
   - For development: `http://localhost:3000`
   - For production: `https://your-domain.com`

## Step 2: Configure the Frontend

1. Copy your OAuth Client ID from the Google Console
2. Open `frontend.html` in your editor
3. Find the line: `const GOOGLE_CLIENT_ID = 'YOUR_GOOGLE_CLIENT_ID_HERE';`
4. Replace `'YOUR_GOOGLE_CLIENT_ID_HERE'` with your actual Client ID

Example:
```javascript
const GOOGLE_CLIENT_ID = '123456789-abcdefghijklmnop.apps.googleusercontent.com';
```

## Step 3: Configure the Backend (Optional)

If you want to enable server-side token verification:

1. Install the Google Auth library:
   ```bash
   pip install google-auth
   ```

2. Update the `GOOGLE_CLIENT_ID` in `src/finviz_scanner/auth.py`:
   ```python
   GOOGLE_CLIENT_ID = "your-actual-client-id-here"
   ```

3. Replace the `verify_google_token_simple` function with proper verification using the google-auth library.

## Step 4: Test the Setup

1. Start your application
2. Open the frontend in your browser
3. You should see a "Login with Gmail" button in the top-right corner
4. Click it to test the authentication flow

## Security Notes

- **Never commit your OAuth credentials to version control**
- For production, use environment variables to store sensitive data
- Consider implementing additional security measures like token refresh
- The current implementation uses client-side token verification for simplicity

## Production Deployment

For production use:

1. Use HTTPS for your domain
2. Add your production domain to Google OAuth settings
3. Use environment variables for configuration
4. Implement proper server-side token verification
5. Add rate limiting and other security measures

## Troubleshooting

### Common Issues:

1. **"Invalid OAuth client"**: Check that your Client ID is correct and the domain is authorized
2. **CORS errors**: Make sure your domain is added to authorized origins
3. **Token verification fails**: Check that the token format is correct and not expired

### Debug Mode:

Open browser developer tools to see authentication logs and any error messages.
