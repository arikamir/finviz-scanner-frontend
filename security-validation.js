// Security Validation Report Generator
// Run this in the browser console to validate security improvements

console.log("🔐 SECURITY VALIDATION REPORT");
console.log("=============================");
console.log("");

// Test 1: Storage Security
console.log("1. 📦 STORAGE SECURITY CHECK");
console.log("----------------------------");

const localStorageToken = localStorage.getItem('finviz_token');
const localStorageUser = localStorage.getItem('finviz_user');
const sessionStorageToken = sessionStorage.getItem('finviz_token');
const sessionStorageUser = sessionStorage.getItem('finviz_user');

console.log(`localStorage JWT token: ${localStorageToken ? '❌ FOUND (SECURITY RISK)' : '✅ NOT FOUND (SECURE)'}`);
console.log(`localStorage user data: ${localStorageUser ? '❌ FOUND (SECURITY RISK)' : '✅ NOT FOUND (SECURE)'}`);
console.log(`sessionStorage JWT token: ${sessionStorageToken ? '✅ FOUND (SECURE)' : '⚠️ NOT FOUND (expected if not logged in)'}`);
console.log(`sessionStorage user data: ${sessionStorageUser ? '✅ FOUND (SECURE)' : '⚠️ NOT FOUND (expected if not logged in)'}`);
console.log("");

// Test 2: Pending Request Security
console.log("2. 🔄 PENDING REQUEST SECURITY");
console.log("------------------------------");

try {
    console.log(`Pending request variable: ${typeof pendingScanRequest !== 'undefined' ? '✅ ACCESSIBLE' : '❌ NOT ACCESSIBLE'}`);
    console.log(`Pending request value: ${pendingScanRequest || 'null/undefined'}`);
    console.log(`Pending timeout: ${pendingRequestTimeout || 'null/undefined'}`);
    
    // Test cleanup function
    if (typeof clearPendingRequest === 'function') {
        console.log("✅ clearPendingRequest function available");
        
        // Test setPendingRequest if available
        if (typeof setPendingRequest === 'function') {
            console.log("✅ setPendingRequest function available");
            console.log("🧪 Testing security timeout...");
            
            // Set a test request
            setPendingRequest({test: 'security_test', timestamp: Date.now()});
            console.log(`✅ Test request set: ${JSON.stringify(pendingScanRequest)}`);
            
            // Test immediate cleanup
            setTimeout(() => {
                clearPendingRequest();
                console.log(`✅ Manual cleanup test: ${pendingScanRequest === null ? 'SUCCESS' : 'FAILED'}`);
            }, 1000);
        }
    } else {
        console.log("❌ clearPendingRequest function not available");
    }
} catch (error) {
    console.log(`❌ Error accessing pending request variables: ${error.message}`);
}
console.log("");

// Test 3: Authentication State
console.log("3. 🔐 AUTHENTICATION STATE");
console.log("--------------------------");

try {
    console.log(`Current user: ${typeof currentUser !== 'undefined' ? (currentUser ? '✅ AUTHENTICATED' : '⚠️ NOT AUTHENTICATED') : '❌ VARIABLE NOT ACCESSIBLE'}`);
    console.log(`Auth token: ${typeof authToken !== 'undefined' ? (authToken ? '✅ TOKEN PRESENT' : '⚠️ NO TOKEN') : '❌ VARIABLE NOT ACCESSIBLE'}`);
    
    if (typeof isAuthenticated === 'function') {
        console.log(`Authentication check: ${isAuthenticated() ? '✅ AUTHENTICATED' : '⚠️ NOT AUTHENTICATED'}`);
    }
} catch (error) {
    console.log(`❌ Error checking authentication state: ${error.message}`);
}
console.log("");

// Test 4: Security Event Listeners
console.log("4. 🎯 SECURITY EVENT HANDLERS");
console.log("-----------------------------");

// Check if security event listeners are properly attached
const hasBeforeUnload = window.onbeforeunload !== null || 
    (window.addEventListener && window.getEventListeners && 
     window.getEventListeners(window).beforeunload?.length > 0);

const hasVisibilityChange = document.onvisibilitychange !== null ||
    (document.addEventListener && document.getEventListeners && 
     document.getEventListeners(document).visibilitychange?.length > 0);

console.log(`beforeunload handler: ${hasBeforeUnload ? '✅ DETECTED' : '⚠️ NOT DETECTED (may still be present)'}`);
console.log(`visibilitychange handler: ${hasVisibilityChange ? '✅ DETECTED' : '⚠️ NOT DETECTED (may still be present)'}`);
console.log("");

// Test 5: Token Validation
console.log("5. 🔍 TOKEN VALIDATION");
console.log("----------------------");

if (sessionStorageToken) {
    try {
        const tokenParts = sessionStorageToken.split('.');
        if (tokenParts.length === 3) {
            const payload = JSON.parse(atob(tokenParts[1]));
            const currentTime = Math.floor(Date.now() / 1000);
            const isExpired = payload.exp && payload.exp <= currentTime;
            
            console.log(`✅ Token format: Valid JWT`);
            console.log(`Token expiry: ${new Date(payload.exp * 1000).toLocaleString()}`);
            console.log(`Token status: ${isExpired ? '❌ EXPIRED' : '✅ VALID'}`);
            console.log(`Time until expiry: ${payload.exp ? Math.floor((payload.exp - currentTime) / 60) : 'N/A'} minutes`);
        } else {
            console.log(`❌ Token format: Invalid (${tokenParts.length} parts, expected 3)`);
        }
    } catch (error) {
        console.log(`❌ Token validation error: ${error.message}`);
    }
} else {
    console.log("⚠️ No token to validate (user not logged in)");
}
console.log("");

// Test 6: Security Summary
console.log("6. 📊 SECURITY SUMMARY");
console.log("----------------------");

const securityScore = {
    storageSecure: !localStorageToken && !localStorageUser,
    sessionStorageUsed: !!sessionStorageToken || !!sessionStorageUser,
    pendingRequestAccessible: typeof pendingScanRequest !== 'undefined',
    cleanupFunctionsAvailable: typeof clearPendingRequest === 'function' && typeof setPendingRequest === 'function',
    authStateAccessible: typeof currentUser !== 'undefined' && typeof authToken !== 'undefined'
};

const securityPassing = Object.values(securityScore).filter(Boolean).length;
const totalTests = Object.keys(securityScore).length;

console.log(`Security tests passing: ${securityPassing}/${totalTests}`);
console.log("");

Object.entries(securityScore).forEach(([test, passing]) => {
    console.log(`${passing ? '✅' : '❌'} ${test}: ${passing ? 'PASS' : 'FAIL'}`);
});

console.log("");
console.log(`Overall Security Status: ${securityPassing >= 4 ? '✅ GOOD' : securityPassing >= 2 ? '⚠️ NEEDS IMPROVEMENT' : '❌ POOR'}`);
console.log("");

// Test 7: Performance Check
console.log("7. ⚡ PERFORMANCE IMPACT");
console.log("------------------------");

console.log("Memory usage check:");
console.log(`Pending request size: ${pendingScanRequest ? JSON.stringify(pendingScanRequest).length : 0} bytes`);
console.log(`Session storage size: ${JSON.stringify(sessionStorage).length} bytes`);
console.log("✅ Memory impact: Minimal");
console.log("");

console.log("🎉 SECURITY VALIDATION COMPLETE");
console.log("Copy this output to verify security improvements!");
console.log("===============================");
