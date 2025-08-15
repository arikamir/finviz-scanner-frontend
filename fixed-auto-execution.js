/**
 * FIXED AUTO-EXECUTION - Handles JWT Decoding Error
 * This fixes the InvalidCharacterError when processing credentials
 * Copy and paste this into browser console
 */

console.log("🔧 APPLYING FIXED AUTO-EXECUTION...");

// Clear any previous overrides to start fresh
delete window.handleCredentialResponse;

// First, let's check what the original function looks like and patch it properly
const originalHandleCredentialResponse = window.handleCredentialResponse;

// Enhanced version that handles both real and mock credentials
window.handleCredentialResponse = function(response) {
    console.log('🔐 Fixed handleCredentialResponse called with:', response);
    
    try {
        // Only process if we have a real credential (not our mock)
        if (response && response.credential && response.credential !== 'mock') {
            console.log('🔍 Processing real credential...');
            
            // Decode the JWT token to get user info
            const payload = JSON.parse(atob(response.credential.split('.')[1]));
            
            window.currentUser = {
                id: payload.sub,
                email: payload.email,
                name: payload.name,
                picture: payload.picture
            };
            
            window.authToken = response.credential;
            
            // Store in sessionStorage
            sessionStorage.setItem('finviz_user', JSON.stringify(window.currentUser));
            sessionStorage.setItem('finviz_token', window.authToken);
            
            console.log('✅ User authenticated:', window.currentUser.name);
            
            // Update UI if functions exist
            if (typeof window.updateAuthUI === 'function') {
                window.updateAuthUI();
            }
        } else {
            console.log('🔍 Mock credential or missing credential, using existing auth state');
            
            // For mock calls, check if we already have auth data
            const existingUser = sessionStorage.getItem('finviz_user');
            const existingToken = sessionStorage.getItem('finviz_token');
            
            if (existingUser && existingToken) {
                window.currentUser = JSON.parse(existingUser);
                window.authToken = existingToken;
                console.log('✅ Using existing auth state for:', window.currentUser.name);
            }
        }
        
        // Hide auth overlay
        if (typeof window.hideAuthOverlay === 'function') {
            window.hideAuthOverlay();
        }
        
        // Check for pending requests
        setTimeout(() => {
            console.log('🔍 Checking for pending requests after authentication...');
            
            const sessionPending = sessionStorage.getItem('pendingRequest');
            
            if (sessionPending) {
                console.log('⚡ Found pending request in sessionStorage');
                try {
                    const scanData = JSON.parse(sessionPending);
                    
                    // Clear the pending request
                    sessionStorage.removeItem('pendingRequest');
                    if (window.clearPendingRequest) {
                        window.clearPendingRequest();
                    }
                    
                    console.log('🚀 Auto-executing scan with data:', scanData);
                    
                    // Verify authentication
                    const isAuth = window.isAuthenticated ? window.isAuthenticated() : (window.currentUser && window.authToken);
                    
                    if (isAuth) {
                        // Show notification
                        const notification = document.createElement('div');
                        notification.style.cssText = `
                            position: fixed;
                            top: 20px;
                            right: 20px;
                            background: #4CAF50;
                            color: white;
                            padding: 15px 20px;
                            border-radius: 5px;
                            z-index: 10000;
                            font-family: Arial, sans-serif;
                            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                            font-size: 14px;
                        `;
                        notification.innerHTML = '🚀 Auto-executing your analysis request...';
                        document.body.appendChild(notification);
                        
                        // Remove notification after 4 seconds
                        setTimeout(() => {
                            if (notification.parentNode) {
                                notification.remove();
                            }
                        }, 4000);
                        
                        // Method 1: Try performScan function first
                        if (typeof window.performScan === 'function') {
                            console.log('📊 Using performScan function');
                            window.performScan(scanData);
                        } 
                        // Method 2: Populate form and trigger submission
                        else {
                            console.log('📝 Populating form and triggering submission');
                            
                            const form = document.getElementById('scanForm');
                            if (form) {
                                // Populate form fields
                                const fields = [
                                    { name: 'screenerUrl', value: scanData.screener_url },
                                    { name: 'maxTickers', value: scanData.max_tickers },
                                    { name: 'portfolioCash', value: scanData.portfolio_cash }
                                ];
                                
                                fields.forEach(field => {
                                    if (field.value) {
                                        const element = form.querySelector(`[name="${field.name}"]`);
                                        if (element) {
                                            element.value = field.value;
                                            console.log(`✅ Set ${field.name}:`, field.value);
                                        }
                                    }
                                });
                                
                                // Handle checkbox
                                if (scanData.market_filter !== undefined) {
                                    const filterField = form.querySelector('[name="marketFilter"]');
                                    if (filterField) {
                                        filterField.checked = scanData.market_filter;
                                        console.log('✅ Set market filter:', scanData.market_filter);
                                    }
                                }
                                
                                // Trigger form submission with delay
                                setTimeout(() => {
                                    console.log('📤 Triggering form submission...');
                                    const submitEvent = new Event('submit', { bubbles: true, cancelable: true });
                                    form.dispatchEvent(submitEvent);
                                    console.log('✅ Form submission triggered');
                                }, 1000);
                            } else {
                                console.log('❌ Form not found for auto-execution');
                            }
                        }
                    } else {
                        console.log('❌ User not authenticated, cannot execute pending request');
                    }
                    
                } catch (error) {
                    console.error('❌ Error executing pending request:', error);
                    sessionStorage.removeItem('pendingRequest');
                }
            } else {
                console.log('ℹ️ No pending request found in sessionStorage');
                
                // Also check the global variable
                if (window.pendingScanRequest) {
                    console.log('⚡ Found pending request in global variable');
                    const scanData = window.pendingScanRequest;
                    window.pendingScanRequest = null;
                    
                    if (typeof window.performScan === 'function') {
                        window.performScan(scanData);
                    }
                }
            }
        }, 1000); // Reduced delay
        
    } catch (error) {
        console.error('❌ Error in handleCredentialResponse:', error);
        
        // Even if there's an error, try to handle pending requests
        setTimeout(() => {
            const sessionPending = sessionStorage.getItem('pendingRequest');
            if (sessionPending) {
                console.log('🔄 Attempting to execute pending request despite error');
                // Clear the pending request and show a message
                sessionStorage.removeItem('pendingRequest');
                alert('Authentication completed. Please click "Analyze Stocks" again to proceed.');
            }
        }, 1000);
    }
};

// Override hideAuthOverlay to also check for pending requests
const originalHideAuthOverlay = window.hideAuthOverlay;
window.hideAuthOverlay = function() {
    console.log('🫥 Hiding auth overlay...');
    
    // Call original function
    if (originalHideAuthOverlay) {
        originalHideAuthOverlay();
    } else {
        // Manual overlay hiding
        const overlay = document.getElementById('authOverlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }
    
    // Remove pending request indicator
    const indicator = document.getElementById('pendingRequestIndicator');
    if (indicator) {
        indicator.remove();
    }
    
    // Small delay then check for pending requests
    setTimeout(() => {
        const sessionPending = sessionStorage.getItem('pendingRequest');
        if (sessionPending) {
            console.log('🔄 Found pending request after hiding overlay, processing...');
            // Trigger our enhanced handleCredentialResponse
            if (window.handleCredentialResponse) {
                // Use mock credential to trigger pending request logic
                window.handleCredentialResponse({ credential: 'mock' });
            }
        }
    }, 500);
};

console.log("✅ FIXED AUTO-EXECUTION APPLIED!");
console.log("🧪 The authentication flow should now work without JWT decoding errors");
console.log("🔄 Try the authentication flow again - it should auto-execute after sign-in");

// Enhanced test function
window.testFixedAutoExecution = function() {
    console.log('🧪 TESTING FIXED AUTO-EXECUTION...');
    
    // Clear auth state
    sessionStorage.removeItem('finviz_token');
    sessionStorage.removeItem('finviz_user');
    window.currentUser = null;
    window.authToken = null;
    
    // Create test pending request
    const testScanData = {
        screener_url: 'https://finviz.com/screener.ashx?v=111&f=sh_avgvol_o500,sh_price_5to50',
        max_tickers: 20,
        market_filter: true,
        portfolio_cash: 10000
    };
    
    if (window.setPendingRequest) {
        window.setPendingRequest(testScanData);
        console.log('✅ Test pending request set');
    }
    
    if (window.showAuthOverlay) {
        window.showAuthOverlay();
        console.log('✅ Auth overlay shown - authenticate to test fixed auto-execution');
    }
};

console.log("🔧 Test function: testFixedAutoExecution()");
