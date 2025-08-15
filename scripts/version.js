#!/usr/bin/env node
/**
 * Semantic Versioning Management Script for Finviz Scanner Frontend
 * 
 * This script helps manage semantic versioning for the frontend package.json.
 * It follows semantic versioning guidelines (semver.org):
 * 
 * - MAJOR version: incompatible API changes
 * - MINOR version: backwards-compatible functionality additions  
 * - PATCH version: backwards-compatible bug fixes
 * 
 * Usage:
 *     node scripts/version.js current                    # Show current version
 *     node scripts/version.js bump patch                 # Bump patch version (1.0.0 -> 1.0.1)
 *     node scripts/version.js bump minor                 # Bump minor version (1.0.0 -> 1.1.0)
 *     node scripts/version.js bump major                 # Bump major version (1.0.0 -> 2.0.0)
 *     node scripts/version.js set 1.2.3                  # Set specific version
 *     node scripts/version.js tag                        # Create git tag for current version
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class VersionManager {
    constructor() {
        this.packagePath = path.join(__dirname, '..', 'package.json');
    }

    getCurrentVersion() {
        if (!fs.existsSync(this.packagePath)) {
            throw new Error(`Could not find package.json at ${this.packagePath}`);
        }

        const packageJson = JSON.parse(fs.readFileSync(this.packagePath, 'utf8'));
        
        if (!packageJson.version) {
            throw new Error('Could not find version in package.json');
        }

        return packageJson.version;
    }

    setVersion(newVersion) {
        // Validate semver format
        const semverRegex = /^\d+\.\d+\.\d+$/;
        if (!semverRegex.test(newVersion)) {
            throw new Error(`Invalid semver format: ${newVersion}`);
        }

        const packageJson = JSON.parse(fs.readFileSync(this.packagePath, 'utf8'));
        packageJson.version = newVersion;

        fs.writeFileSync(this.packagePath, JSON.stringify(packageJson, null, 2) + '\n');
        console.log(`✅ Updated version to ${newVersion} in package.json`);
    }

    bumpVersion(part) {
        const current = this.getCurrentVersion();
        const [major, minor, patch] = current.split('.').map(Number);

        let newMajor = major;
        let newMinor = minor;
        let newPatch = patch;

        switch (part) {
            case 'major':
                newMajor += 1;
                newMinor = 0;
                newPatch = 0;
                break;
            case 'minor':
                newMinor += 1;
                newPatch = 0;
                break;
            case 'patch':
                newPatch += 1;
                break;
            default:
                throw new Error(`Invalid bump part: ${part}`);
        }

        const newVersion = `${newMajor}.${newMinor}.${newPatch}`;
        this.setVersion(newVersion);
        return newVersion;
    }

    createGitTag(version = null) {
        if (version === null) {
            version = this.getCurrentVersion();
        }

        const tagName = `v${version}`;

        try {
            // Check if tag already exists
            const existingTags = execSync('git tag -l', { encoding: 'utf8' });
            
            if (existingTags.includes(tagName)) {
                console.log(`⚠️  Tag ${tagName} already exists`);
                return false;
            }

            // Ensure we're on the main branch for releases
            const currentBranch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
            if (currentBranch !== 'main') {
                console.log(`⚠️  Not on main branch (currently on ${currentBranch}). Consider switching to main for releases.`);
            }

            // Create annotated tag
            execSync(`git tag -a ${tagName} -m "Release version ${version}

This release includes:
- Frontend version ${version}
- Docker images: arikamir/finviz-scanner-frontend:${version}
- Multi-architecture support (AMD64/ARM64)
- Production-ready nginx configuration"`, { stdio: 'inherit' });
            
            console.log(`✅ Created git tag ${tagName}`);
            console.log(`💡 Push with: git push origin ${tagName}`);
            return true;

        } catch (error) {
            console.error(`❌ Failed to create git tag: ${error.message}`);
            return false;
        }
    }

    pushTag(version = null) {
        if (version === null) {
            version = this.getCurrentVersion();
        }

        const tagName = `v${version}`;

        try {
            execSync(`git push origin ${tagName}`, { stdio: 'inherit' });
            console.log(`✅ Pushed tag ${tagName} to origin`);
            return true;
        } catch (error) {
            console.error(`❌ Failed to push tag: ${error.message}`);
            return false;
        }
    }

    createRelease(part) {
        const oldVersion = this.getCurrentVersion();
        
        console.log(`🚀 Creating ${part} release...`);
        console.log(`Current version: ${oldVersion}`);
        
        // Bump version
        const newVersion = this.bumpVersion(part);
        console.log(`New version: ${newVersion}`);
        
        // Commit version change
        try {
            execSync('git add package.json', { stdio: 'inherit' });
            execSync(`git commit -m "chore: bump version to ${newVersion}"`, { stdio: 'inherit' });
            console.log(`✅ Committed version bump`);
        } catch (error) {
            console.error(`❌ Failed to commit version change: ${error.message}`);
            return false;
        }
        
        // Create and push tag
        if (this.createGitTag(newVersion)) {
            console.log(`🏷️  Tag created successfully`);
            console.log(`📦 Docker images will be built with tag: ${newVersion}`);
            console.log(`🌐 This will trigger CI/CD to publish to Docker Hub`);
            console.log(`\n💡 Next steps:`);
            console.log(`   1. git push origin main`);
            console.log(`   2. git push origin v${newVersion}`);
            console.log(`   3. Monitor CI/CD pipeline for Docker Hub publish`);
            return true;
        }
        
        return false;
    }
}

function main() {
    const args = process.argv.slice(2);
    const command = args[0];

    if (!command) {
        console.log(`
Usage:
    node scripts/version.js current                    # Show current version
    node scripts/version.js bump <major|minor|patch>   # Bump version
    node scripts/version.js set <version>              # Set specific version
    node scripts/version.js tag                        # Create git tag for current version
    node scripts/version.js release <major|minor|patch> # Full release workflow (bump + commit + tag)
        `);
        return;
    }

    const versionManager = new VersionManager();

    try {
        switch (command) {
            case 'current':
                const version = versionManager.getCurrentVersion();
                console.log(`Current version: ${version}`);
                break;

            case 'bump':
                const part = args[1];
                if (!part || !['major', 'minor', 'patch'].includes(part)) {
                    throw new Error('Bump command requires part: major, minor, or patch');
                }
                const oldVersion = versionManager.getCurrentVersion();
                const newVersion = versionManager.bumpVersion(part);
                console.log(`🚀 Bumped ${part} version: ${oldVersion} → ${newVersion}`);
                break;

            case 'set':
                const targetVersion = args[1];
                if (!targetVersion) {
                    throw new Error('Set command requires a version (e.g., 1.2.3)');
                }
                const currentVersion = versionManager.getCurrentVersion();
                versionManager.setVersion(targetVersion);
                console.log(`🚀 Version changed: ${currentVersion} → ${targetVersion}`);
                break;

            case 'tag':
                versionManager.createGitTag();
                break;

            case 'release':
                const releasePart = args[1];
                if (!releasePart || !['major', 'minor', 'patch'].includes(releasePart)) {
                    throw new Error('Release command requires part: major, minor, or patch');
                }
                versionManager.createRelease(releasePart);
                break;

            default:
                throw new Error(`Unknown command: ${command}`);
        }

    } catch (error) {
        console.error(`❌ Error: ${error.message}`);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = VersionManager;
