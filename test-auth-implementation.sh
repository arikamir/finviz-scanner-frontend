#!/bin/bash
# Testing Script for Auth Flow Fix & Security Improvements
# Based on TESTING_CHECKLIST.md

echo "🧪 Starting Authentication Flow & Security Testing"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test status tracking
TESTS_PASSED=0
TESTS_FAILED=0

# Function to log test results
log_test() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        [ -n "$details" ] && echo "   Details: $details"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name"
        [ -n "$details" ] && echo "   Details: $details"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    echo ""
}

# Function to prompt for manual testing
prompt_manual_test() {
    local test_description="$1"
    echo -e "${BLUE}🔍 MANUAL TEST:${NC} $test_description"
    echo "Please complete this test manually and press any key when done..."
    read -n 1 -s
    echo ""
}

echo "🌐 Frontend URL: http://localhost:8080"
echo "⚠️  Note: For full testing, ensure the backend API is also running"
echo ""

echo "================================"
echo "1. 🔐 SECURITY VALIDATION TESTS"
echo "================================"

# Check if sessionStorage is being used instead of localStorage
echo -e "${YELLOW}Testing sessionStorage implementation...${NC}"
echo "Open browser console and run:"
echo "  sessionStorage.clear();"
echo "  // Check that tokens are stored in sessionStorage, not localStorage"
echo "  localStorage.getItem('finviz_token'); // Should be null"
echo "  sessionStorage.getItem('finviz_token'); // Should have token after auth"
echo ""

prompt_manual_test "Verify sessionStorage usage (see console commands above)"

echo "==============================="
echo "2. 🚀 AUTH FLOW TESTING"
echo "==============================="

echo -e "${YELLOW}Test 1: Anonymous User Flow (Primary Fix)${NC}"
echo "Steps to test:"
echo "1. Clear sessionStorage: sessionStorage.clear()"
echo "2. Refresh the page"
echo "3. Fill in the screener form (any valid URL)"
echo "4. Click 'Analyze Stocks'"
echo "5. Verify auth overlay appears with pending request indicator"
echo "6. Complete Google OAuth login"
echo "7. Verify analysis runs automatically"
echo ""

prompt_manual_test "Anonymous user flow - single click analyze after auth"

echo -e "${YELLOW}Test 2: Authenticated User Flow (Regression Test)${NC}"
echo "Steps to test:"
echo "1. Ensure user is already logged in"
echo "2. Fill in the screener form"
echo "3. Click 'Analyze Stocks'"
echo "4. Verify analysis starts immediately (no auth overlay)"
echo ""

prompt_manual_test "Authenticated user flow - immediate analysis"

echo -e "${YELLOW}Test 3: Pending Request Security Timeout${NC}"
echo "Steps to test:"
echo "1. Clear sessionStorage and refresh"
echo "2. Fill form and click 'Analyze Stocks' (don't login)"
echo "3. Wait or manually trigger timeout:"
echo "   setTimeout(() => { clearPendingRequest(); }, 1000); // 1 second for testing"
echo "4. Verify pending request is cleared"
echo ""

prompt_manual_test "Pending request timeout functionality"

echo "================================"
echo "3. 🎯 USER EXPERIENCE TESTS"
echo "================================"

echo -e "${YELLOW}Test 1: Visual Feedback${NC}"
echo "Check that:"
echo "- Pending request indicator appears when needed"
echo "- Auth messages change appropriately"
echo "- Loading states work correctly"
echo ""

prompt_manual_test "Visual feedback and messaging"

echo -e "${YELLOW}Test 2: Error Handling${NC}"
echo "Test scenarios:"
echo "- Network disconnection during analysis"
echo "- Invalid screener URL"
echo "- Auth cancellation"
echo ""

prompt_manual_test "Error handling scenarios"

echo "================================"
echo "4. 🔒 SECURITY FEATURE TESTS"
echo "================================"

echo -e "${YELLOW}Browser Console Security Tests${NC}"
echo "Run these commands in browser console:"
echo ""
echo "// Test 1: Verify no localStorage usage"
echo "localStorage.getItem('finviz_token'); // Should be null"
echo "localStorage.getItem('finviz_user');  // Should be null"
echo ""
echo "// Test 2: Verify sessionStorage usage"
echo "sessionStorage.getItem('finviz_token'); // Should have token when logged in"
echo "sessionStorage.getItem('finviz_user');  // Should have user data when logged in"
echo ""
echo "// Test 3: Check pending request security"
echo "console.log('Pending request:', pendingScanRequest);"
echo "console.log('Pending timeout:', pendingRequestTimeout);"
echo ""
echo "// Test 4: Test cleanup functions"
echo "setPendingRequest({test: true});"
echo "clearPendingRequest();"
echo "console.log('After clear:', pendingScanRequest); // Should be null"
echo ""

prompt_manual_test "Browser console security validation"

echo "================================"
echo "5. 🌐 EDGE CASE TESTS"
echo "================================"

echo -e "${YELLOW}Test 1: Page Visibility Changes${NC}"
echo "1. Set a pending request"
echo "2. Switch to another tab for 1+ minute"
echo "3. Return and verify request was cleared"
echo ""

prompt_manual_test "Page visibility cleanup"

echo -e "${YELLOW}Test 2: Page Refresh${NC}"
echo "1. Set a pending request (don't login)"
echo "2. Refresh the page"
echo "3. Verify pending request doesn't persist"
echo ""

prompt_manual_test "Page refresh behavior"

echo -e "${YELLOW}Test 3: Multiple Rapid Clicks${NC}"
echo "1. Clear auth and refresh"
echo "2. Click 'Analyze Stocks' multiple times rapidly"
echo "3. Verify only one auth overlay and one pending request"
echo ""

prompt_manual_test "Rapid clicks handling"

echo "================================"
echo "📊 TESTING SUMMARY"
echo "================================"

echo "Manual testing completed!"
echo ""
echo -e "${BLUE}🔍 Additional Validation:${NC}"
echo "1. Check browser console for errors"
echo "2. Verify no memory leaks (check browser dev tools)"
echo "3. Test with different browsers (Chrome, Firefox, Safari)"
echo "4. Verify HTTPS behavior if applicable"
echo ""

echo -e "${GREEN}✅ Key Success Criteria:${NC}"
echo "- Single-click analysis for anonymous users"
echo "- No regression for authenticated users"
echo "- sessionStorage instead of localStorage"
echo "- Automatic pending request cleanup"
echo "- Enhanced user feedback"
echo ""

echo -e "${YELLOW}⚠️  Security Notes:${NC}"
echo "- Tokens now clear when tab closes (sessionStorage)"
echo "- Pending requests timeout after 5 minutes"
echo "- No sensitive data stored in pending requests"
echo "- Multiple cleanup mechanisms active"
echo ""

echo "Testing script completed. Review all manual test results above."
echo "If all tests pass, the implementation is ready for production!"
