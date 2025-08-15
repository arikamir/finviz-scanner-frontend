/**
 * FIX AUTO-EXECUTION AFTER AUTHENTICATION
 * This addresses the issue where analysis doesn't execute automatically after authentication
 * Copy and paste this into browser console
 */

console.log("🔧 FIXING AUTO-EXECUTION AFTER AUTHENTICATION...");

// Problem: The handleCredentialResponse function checks pendingScanRequest (global variable)
// but our browser fix stores pending requests in sessionStorage

// Solution: Override handleCredentialResponse to check both places

const originalHandleCredentialResponse = window.handleCredentialResponse;

if (originalHandleCredentialResponse) {
    window.handleCredentialResponse = function(response) {
        console.log('🔐 Enhanced handleCredentialResponse called');
        
        // Call the original function first
        try {
            originalHandleCredentialResponse(response);
        } catch (error) {
            console.log('⚠️ Error in original handleCredentialResponse:', error);
        }
        
        // Additional logic to handle sessionStorage pending requests
        setTimeout(() => {
            console.log('🔍 Checking for pending requests...');
            
            // Check sessionStorage for pending request (from our browser fix)
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
                    
                    // Check if user is authenticated
                    if (window.isAuthenticated && window.isAuthenticated()) {
                        // Method 1: Try to call performScan if it exists
                        if (typeof window.performScan === 'function') {
                            console.log('📊 Using performScan function');
                            window.performScan(scanData);
                        } 
                        // Method 2: Populate form and trigger submission
                        else {
                            console.log('📝 Populating form and triggering submission');
                            
                            const form = document.getElementById('scanForm');
                            if (form) {
                                // Populate form fields with pending data
                                if (scanData.screener_url) {
                                    const urlField = form.querySelector('[name="screenerUrl"]');
                                    if (urlField) {
                                        urlField.value = scanData.screener_url;
                                        console.log('✅ Set screener URL:', scanData.screener_url);
                                    }
                                }
                                
                                if (scanData.max_tickers) {
                                    const tickersField = form.querySelector('[name="maxTickers"]');
                                    if (tickersField) {
                                        tickersField.value = scanData.max_tickers;
                                        console.log('✅ Set max tickers:', scanData.max_tickers);
                                    }
                                }
                                
                                if (scanData.portfolio_cash) {
                                    const cashField = form.querySelector('[name="portfolioCash"]');
                                    if (cashField) {
                                        cashField.value = scanData.portfolio_cash;
                                        console.log('✅ Set portfolio cash:', scanData.portfolio_cash);
                                    }
                                }
                                
                                if (scanData.market_filter) {
                                    const filterField = form.querySelector('[name="marketFilter"]');
                                    if (filterField) {
                                        filterField.checked = scanData.market_filter;
                                        console.log('✅ Set market filter:', scanData.market_filter);
                                    }
                                }
                                
                                // Show a notification that auto-execution is happening
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
                                `;
                                notification.innerHTML = '🚀 Auto-executing your analysis request...';
                                document.body.appendChild(notification);
                                
                                // Remove notification after 3 seconds
                                setTimeout(() => notification.remove(), 3000);
                                
                                // Trigger form submission
                                setTimeout(() => {
                                    const submitEvent = new Event('submit', { bubbles: true, cancelable: true });
                                    form.dispatchEvent(submitEvent);
                                    console.log('✅ Form submission triggered');
                                }, 500);
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
                console.log('ℹ️ No pending request found');
            }
        }, 1500); // Increased delay to ensure authentication is fully processed
    };
    
    console.log('✅ handleCredentialResponse enhanced for auto-execution');
} else {
    console.log('❌ Original handleCredentialResponse not found');
}

// Also enhance the hideAuthOverlay function to check for pending requests
const originalHideAuthOverlay = window.hideAuthOverlay;
if (originalHideAuthOverlay) {
    window.hideAuthOverlay = function() {
        originalHideAuthOverlay();
        
        // Double-check for pending requests after hiding overlay
        setTimeout(() => {
            const sessionPending = sessionStorage.getItem('pendingRequest');
            if (sessionPending && window.isAuthenticated && window.isAuthenticated()) {
                console.log('🔄 Found pending request after overlay hidden, executing...');
                // Trigger our enhanced handleCredentialResponse logic
                if (window.handleCredentialResponse) {
                    // Create a mock response to trigger the pending request check
                    window.handleCredentialResponse({ credential: sessionStorage.getItem('finviz_token') || 'mock' });
                }
            }
        }, 1000);
    };
}

console.log("\n✅ AUTO-EXECUTION FIX APPLIED!");
console.log("🧪 TEST: Try logging out, then click 'Analyze Stocks' and authenticate");
console.log("📊 The analysis should now execute automatically after authentication");

// Test function to simulate the flow
window.testAutoExecution = function() {
    console.log('🧪 TESTING AUTO-EXECUTION...');
    
    // Clear auth state
    sessionStorage.removeItem('finviz_token');
    sessionStorage.removeItem('finviz_user');
    window.currentUser = null;
    window.authToken = null;
    
    // Create a test pending request
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
        console.log('✅ Auth overlay shown - authenticate to test auto-execution');
    }
};

console.log("\n🔧 Additional test function available: testAutoExecution()");
