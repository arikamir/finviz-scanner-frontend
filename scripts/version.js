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

        const tagName = `frontend-v${version}`;

        try {
            // Check if tag already exists
            const existingTags = execSync('git tag -l', { encoding: 'utf8' });
            
            if (existingTags.includes(tagName)) {
                console.log(`⚠️  Tag ${tagName} already exists`);
                return;
            }

            // Create annotated tag
            execSync(`git tag -a ${tagName} -m "Frontend release version ${version}"`, { stdio: 'inherit' });
            
            console.log(`✅ Created git tag ${tagName}`);
            console.log(`💡 Push with: git push origin ${tagName}`);

        } catch (error) {
            console.error(`❌ Failed to create git tag: ${error.message}`);
        }
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
