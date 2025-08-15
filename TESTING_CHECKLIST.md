# Testing Checklist: Auth Flow Fix & Security Improvements

## 🧪 Test Scenarios

### 1. Anonymous User Flow (Primary Fix)
**Scenario**: User not logged in clicks "Analyze Stocks"

**Expected Behavior**:
- [ ] Auth overlay appears immediately
- [ ] Pending request indicator shows: "📋 Your analysis request is ready!"
- [ ] Message changes to: "Please sign in to continue with your stock analysis."
- [ ] After Google OAuth login → Analysis runs automatically
- [ ] Results display without requiring second click
- [ ] Pending request is cleared after execution

**Test Steps**:
1. Clear sessionStorage: `sessionStorage.clear()`
2. Refresh page
3. Fill in screener form (URL, tickers, etc.)
4. Click "Analyze Stocks"
5. Verify auth overlay with pending indicator
6. Complete Google OAuth
7. Verify automatic analysis execution

### 2. Authenticated User Flow (No Regression)
**Scenario**: User already logged in clicks "Analyze Stocks"

**Expected Behavior**:
- [ ] Analysis starts immediately
- [ ] No auth overlay shown
- [ ] Results display normally
- [ ] No change from previous behavior

**Test Steps**:
1. Ensure user is logged in
2. Fill in screener form
3. Click "Analyze Stocks"
4. Verify immediate analysis execution

### 3. Token Expiry Scenarios
**Scenario A**: Token expires before clicking analyze

**Expected Behavior**:
- [ ] Auth overlay shown on page load
- [ ] User can proceed with normal flow

**Scenario B**: Token expires during analysis

**Expected Behavior**:
- [ ] Request stored as pending
- [ ] Auth overlay appears
- [ ] After re-auth → Analysis continues automatically

**Test Steps**:
1. Manually expire token in sessionStorage
2. Try to analyze
3. Verify graceful re-authentication

### 4. Security Features
**Test A**: SessionStorage vs LocalStorage
- [ ] Tokens stored in sessionStorage (not localStorage)
- [ ] Tokens cleared when tab is closed
- [ ] Tokens persist within same session

**Test B**: Pending Request Timeout
- [ ] Pending request cleared after 5 minutes
- [ ] Console log: "🔒 Pending request cleared for security"

**Test C**: Page Visibility Changes
- [ ] Pending request cleared when tab hidden for 1 minute
- [ ] No clearing if tab becomes visible again quickly

**Test D**: Page Unload
- [ ] Pending request cleared on page unload/refresh
- [ ] No memory leaks

### 5. User Experience Tests
**Test A**: Visual Feedback
- [ ] Pending request indicator appears only when request is stored
- [ ] Auth message changes appropriately
- [ ] Loading states work correctly

**Test B**: Error Handling
- [ ] Network errors handled gracefully
- [ ] Auth failures show appropriate messages
- [ ] Token validation errors trigger re-auth

**Test C**: Multiple Requests
- [ ] New analyze click overwrites previous pending request
- [ ] Only one request stored at a time
- [ ] Timeout resets with new request

### 6. Edge Cases
**Test A**: Rapid Clicks
- [ ] Multiple rapid clicks on "Analyze" handled properly
- [ ] No duplicate requests stored
- [ ] UI remains responsive

**Test B**: Auth During Loading
- [ ] If user logs out during analysis → graceful handling
- [ ] If token expires mid-request → proper re-auth

**Test C**: Browser Refresh
- [ ] Pending requests don't persist across page refreshes
- [ ] Auth state properly restored if token valid

## 🔧 Testing Commands

### Local Development Setup
```bash
cd /Users/arikamir/workspace/amir-scanner/frontend
make dev
```

### Browser Console Commands for Testing
```javascript
// Clear all auth data
sessionStorage.clear();
pendingScanRequest = null;

// Check current auth state
console.log('User:', currentUser);
console.log('Token:', authToken);
console.log('Pending:', pendingScanRequest);

// Manually expire token
if (authToken) {
    const parts = authToken.split('.');
    const payload = JSON.parse(atob(parts[1]));
    payload.exp = Math.floor(Date.now() / 1000) - 3600; // 1 hour ago
    // Note: This won't actually change the stored token, 
    // just for testing the expiry check logic
}

// Test pending request timeout (for dev testing)
setPendingRequest({test: true});
// Check after 5 minutes or trigger manually:
clearPendingRequest();
```

### Security Validation
```javascript
// Verify sessionStorage usage
console.log('localStorage token:', localStorage.getItem('finviz_token')); // Should be null
console.log('sessionStorage token:', sessionStorage.getItem('finviz_token')); // Should have token

// Test timeout functionality
setPendingRequest({screener_url: 'test'});
console.log('Pending request set, wait 5 minutes...');
```

## ✅ Success Criteria

### Primary Goal (Auth Flow Fix)
- [ ] **Single-click analysis** for anonymous users
- [ ] **Seamless authentication** flow
- [ ] **No data loss** during auth process

### Security Goals
- [ ] **No localStorage** JWT storage
- [ ] **Request timeouts** working
- [ ] **Memory cleanup** on page events

### UX Goals
- [ ] **Clear feedback** about pending requests
- [ ] **No regressions** for authenticated users
- [ ] **Graceful error handling**

## 🐛 Known Issues to Watch For

1. **Race Conditions**: Multiple auth attempts
2. **Memory Leaks**: Pending request not cleared
3. **Token Refresh**: Google tokens can't be refreshed client-side
4. **CORS Issues**: If API URL misconfigured

## 📊 Performance Impact

- **Memory**: Minimal (one pending request object)
- **Network**: No additional requests
- **UI**: Slightly improved (fewer clicks)
- **Security**: Significantly improved

## 🚀 Deployment Checklist

- [ ] All tests pass
- [ ] No console errors
- [ ] Security improvements verified
- [ ] UX flow tested end-to-end
- [ ] Documentation updated
- [ ] Ready for production deployment
