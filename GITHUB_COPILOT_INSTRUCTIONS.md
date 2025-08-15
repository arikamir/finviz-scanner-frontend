# GitHub Copilot Development Instructions - Frontend Repository

This document outlines the development workflow and guidelines for the **Finviz Scanner Frontend** project when working with GitHub Copilot.

## 🏗️ Repository Structure

This is the **frontend repository** containing:
- `frontend.html` - Main web application interface
- `auth-test.html` - Authentication testing page
- Docker configuration files
- Deployment scripts and SSL setup
- Documentation and setup guides

**Note**: The backend Python package has its own separate repository at [finviz-scanner](https://github.com/arikamir/finviz-scanner)

## 🔄 Development Workflow

### Branching Strategy

**All feature development MUST follow this branching strategy:**

1. **Main Branch Protection**: The `main` branch is protected and requires pull requests
2. **Feature Branches**: All new features, bug fixes, and improvements must be developed on feature branches
3. **Branch Naming Convention**: Use descriptive names following this pattern:
   - `feature/description` - for new features
   - `bugfix/description` - for bug fixes
   - `enhancement/description` - for improvements
   - `docs/description` - for documentation updates
   - `deploy/description` - for deployment-related changes
   - `auth/description` - for authentication-related changes

### Required Workflow Steps

#### 1. Create Feature Branch
```bash
# Ensure you're on main and up to date
git checkout main
git pull origin main

# Create and switch to feature branch
git checkout -b feature/your-feature-name

# Examples:
git checkout -b feature/add-dark-mode
git checkout -b feature/improve-mobile-ui
git checkout -b bugfix/fix-auth-redirect
git checkout -b enhancement/optimize-loading
git checkout -b auth/add-multi-factor-auth
git checkout -b deploy/add-kubernetes-config
```

#### 2. Development with GitHub Copilot
- Use GitHub Copilot to assist with frontend code generation
- Follow modern web development standards and patterns
- Ensure responsive design and accessibility
- Test across different browsers and devices

#### 3. Local Testing Before Push
```bash
# Test the frontend locally
open frontend.html

# Test authentication
open auth-test.html

# If using Docker, test the full stack
docker-compose up -d

# Test SSL configuration (if applicable)
# Check deployment scripts
./deployment/docker-build.sh
```

#### 4. Commit and Push Feature Branch
```bash
# Stage changes
git add .

# Commit with descriptive message following conventional commits
git commit -m "feat: add dark mode toggle to frontend

- Implement dark/light theme switcher
- Update CSS variables for theme support
- Add user preference persistence
- Ensure accessibility compliance
- Test across all supported browsers"

# Push feature branch
git push -u origin feature/your-feature-name
```

#### 5. Create Pull Request
- Navigate to GitHub repository: https://github.com/arikamir/finviz-scanner-frontend (to be created)
- Create pull request from feature branch to `main`
- Use the pull request template (see below)

## ✅ Pull Request Requirements

### Mandatory Checks Before Merge Approval

**ALL of the following must pass before a pull request can be merged:**

1. **✅ Frontend Functionality**
   - HTML/CSS/JavaScript syntax is valid
   - No console errors in browser developer tools
   - All features work as expected across browsers

2. **✅ Authentication Testing**
   - Gmail OAuth flow works correctly
   - Authentication states handled properly
   - Token validation and session management working

3. **✅ Responsive Design**
   - Mobile compatibility verified
   - Desktop compatibility verified
   - Tablet compatibility verified
   - Accessibility standards met

4. **✅ Docker & Deployment**
   - Docker containers build successfully
   - Docker-compose configuration works
   - Deployment scripts execute without errors
   - SSL configuration (if modified) tested

5. **✅ GitHub Copilot Code Review**
   - Copilot suggestions reviewed and implemented where appropriate
   - Code follows modern web development best practices
   - Security considerations addressed (XSS, CSRF, etc.)

6. **✅ Integration Testing**
   - Frontend integrates properly with backend API
   - Authentication flow end-to-end tested
   - Error handling tested and working

## 📝 Pull Request Template

When creating a pull request, use this template:

```markdown
## Description
Brief description of the changes and why they were made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] UI/UX improvement
- [ ] Authentication enhancement
- [ ] Deployment/Infrastructure change

## Frontend Changes Made
- List of specific UI/UX changes
- JavaScript functionality updates
- CSS/styling modifications
- Authentication flow changes
- New dependencies or configuration changes

## Testing
- [ ] I have tested the frontend in Chrome/Chromium
- [ ] I have tested the frontend in Firefox
- [ ] I have tested the frontend in Safari (if on macOS)
- [ ] I have tested responsive design on mobile devices
- [ ] I have tested authentication flow end-to-end
- [ ] I have tested integration with backend API
- [ ] Docker containers build and run successfully

## Browser Compatibility
- [ ] Chrome/Chromium (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile browsers tested

## Copilot Integration
- [ ] Used GitHub Copilot for code generation where appropriate
- [ ] Reviewed and validated all Copilot suggestions
- [ ] Ensured generated code follows web standards
- [ ] Security implications of generated code reviewed

## Security Checklist
- [ ] No sensitive data exposed in frontend code
- [ ] Authentication tokens handled securely
- [ ] XSS prevention measures in place
- [ ] CSRF protection maintained
- [ ] Input validation implemented

## Documentation
- [ ] Updated README.md if needed
- [ ] Updated setup guides if needed
- [ ] Added comments to complex JavaScript functions
- [ ] Updated deployment documentation

## Deployment Checklist
- [ ] Changes work in development environment
- [ ] Docker configuration updated if needed
- [ ] SSL configuration tested (if applicable)
- [ ] Deployment scripts work correctly
```

## 🛡️ Branch Protection Rules

The following rules are enforced on the `main` branch:

1. **Require pull request reviews**
2. **Require status checks to pass before merging**
3. **Require branches to be up to date before merging**
4. **Include administrators** (applies to all users)
5. **Require linear history** (no merge commits)

## 🤖 GitHub Copilot Best Practices for Frontend

### When Using Copilot for This Project:

1. **Frontend Code Generation Guidelines:**
   - Always review Copilot suggestions for security implications
   - Ensure generated HTML is semantic and accessible
   - Validate CSS for cross-browser compatibility
   - Test JavaScript for modern browser support

2. **Authentication Code:**
   - Be extra careful with authentication-related code
   - Review OAuth implementation suggestions thoroughly
   - Ensure token handling follows security best practices
   - Test authentication flows comprehensively

3. **UI/UX Development:**
   - Use Copilot to generate responsive CSS
   - Ensure accessibility attributes are included
   - Follow modern design patterns and principles
   - Generate consistent styling across components

4. **Docker & Deployment:**
   - Review Dockerfile suggestions for security
   - Validate docker-compose configurations
   - Test deployment scripts before committing
   - Ensure SSL configurations are secure

## 🎨 Frontend-Specific Guidelines

### HTML Best Practices:
- Use semantic HTML5 elements
- Include proper meta tags for SEO and responsiveness
- Ensure accessibility with ARIA labels and roles
- Validate HTML syntax

### CSS Best Practices:
- Use CSS custom properties (variables) for theming
- Implement mobile-first responsive design
- Use flexbox and grid for layouts
- Optimize for performance (minimize reflows/repaints)

### JavaScript Best Practices:
- Use modern ES6+ syntax
- Implement proper error handling
- Avoid global variables and namespace pollution
- Use async/await for asynchronous operations
- Comment complex authentication logic

### Authentication Frontend Guidelines:
- Never store sensitive data in localStorage/sessionStorage
- Implement proper token expiration handling
- Use secure cookie settings when applicable
- Handle authentication errors gracefully
- Provide clear user feedback for auth states

## 🚫 Prohibited Actions

**The following actions are NOT allowed:**

1. **❌ Direct commits to main branch**
2. **❌ Force pushing to main branch**
3. **❌ Merging pull requests without passing all checks**
4. **❌ Bypassing code review requirements**
5. **❌ Accepting Copilot suggestions without review**
6. **❌ Committing sensitive data (API keys, tokens, etc.)**
7. **❌ Breaking authentication security measures**

## 🔧 Automated Checks Configuration

### GitHub Actions Workflow (to be implemented)

The repository should include automated checks that run on every pull request:

```yaml
# .github/workflows/frontend-ci.yml (example)
name: Frontend CI/CD Pipeline

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js (if using build tools)
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Validate HTML
        run: |
          # HTML validation
          curl -H "Content-Type: text/html; charset=utf-8" \
               --data-binary @frontend.html \
               https://validator.w3.org/nu/?out=gnu
      
      - name: Test Docker Build
        run: |
          docker build --target production -t finviz-frontend .
          docker run --rm finviz-frontend
      
      - name: Test Docker Compose
        run: |
          docker-compose -f docker-compose.yml config
      
      - name: Security Scan
        run: |
          # Scan for sensitive data in commits
          git log --oneline | head -10

  deployment-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Test Deployment Scripts
        run: |
          chmod +x deployment/*.sh
          # Test script syntax
          bash -n deployment/docker-build.sh
          bash -n deployment/docker-manage.sh
```

## 📊 Quality Gates

### Minimum Requirements for Merge:

- **Browser Compatibility**: Works in all major browsers
- **Responsive Design**: Mobile and desktop compatibility verified
- **Authentication Security**: OAuth flow secure and tested
- **Performance**: No significant performance regressions
- **Accessibility**: WCAG 2.1 AA compliance maintained

## 🆘 Emergency Procedures

### Hotfix Process (for critical frontend issues):

1. Create hotfix branch from `main`: `git checkout -b hotfix/critical-frontend-issue`
2. Make minimal necessary changes
3. Test in production-like environment
4. Follow accelerated review process
5. Merge after essential checks pass
6. Create follow-up feature branch for comprehensive fix

## 🔗 Related Repositories

- **Backend API**: [finviz-scanner](https://github.com/arikamir/finviz-scanner) (separate repository)
- **Documentation**: Include links to backend API docs for integration reference

## 📞 Support and Questions

For questions about this workflow or GitHub Copilot integration:

1. Check existing documentation in `docs/` directory
2. Review previous pull requests for examples
3. Consult GitHub Copilot documentation
4. Create an issue in the repository for workflow clarifications
5. Refer to backend repository for API integration questions

---

**Remember**: This workflow ensures frontend code quality, maintains security standards, and leverages GitHub Copilot effectively while maintaining human oversight for critical authentication and security features.
