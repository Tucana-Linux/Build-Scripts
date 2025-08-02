# Tucana-Build-Scripts
This is a mono-repo that is home to all of the Tucana Build Scripts

##  Overview

- **2,000+ packages** built from source using standardized templates.
- **Autobuild system** performs nightly rebuilds; over **9,000 commits** processed to date.
- **Self-healing design**: if a package fails to update cleanly, the system reverts and logs the issue for manual review.
- **~90–95% success rate** on most daily runs.

> The latest commit often reads `"Failed to update <package>"` — this is expected and reflects our continuous build strategy where most packages succeed but a few fail due to upstream changes.

# Adding a package
Packages can be added by copying one of the many available templates from the templates/ folder and filling in the URL, build-system command arguments, and dependencies. Once you do that you'll probably want to keep it up to date, see https://github.com/Tucana-Linux/Tucana-Autobuild for details on how to add a package to autobuild.

# Repo management
This branch of the build-scripts repository is basically on autopilot because of Autobuild, every so often (usually once every 1-2 weeks) I'll come in and fix any of the failures Autobuild couldn't remedy automatically, that's why you'll see a Failed to update commit as the most recent practically every day of the week. 

**For historical package versions and prebuilt binaries**, visit:  
https://git.magnium.org/mainline/repository/ (click **packages**)


# PRs/Contributing 
If you want to fix anything feel free to open a PR or issue, help is always appreciated!
