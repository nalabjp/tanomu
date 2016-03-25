# Tanomu

[![Build Status](https://travis-ci.org/ppworks/tanomu.svg?branch=master)](https://travis-ci.org/ppworks/tanomu)

**Tanomu** is an auto assigning tool for Pull Request.

When you open a Pull Request which has no assignee and title doesn't start with "WIP", "[WIP]" or "(WIP)", **Tanomu** will automatically assign a member of team which name is same as repository name on the Pull Request.

If you want to assign Pull Request to a member of specified team, please create Pull Request with a description include `ASSIGN_PHRASE`.

If you want to assign Pull Request to a member of specified team after create Pull request, please post a comment with description include `ASSIGN_PHRASE`.

Default `ASSIGN_PHRASE` is 'Please assign %team'.

## Setup

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### SECRET_TOKEN

Please set secret token for GitHub Webhook which you'll put on 'secret' field.

![image](https://cloud.githubusercontent.com/assets/536118/14043002/eacbf994-f2c2-11e5-9c6e-9ae5f5ae7687.png)

### GITHUB_API_TOKEN

Please set Personal access token for your GitHub account(or Bot account) which has following permissions.

![image](https://cloud.githubusercontent.com/assets/536118/14044264/cb5865ca-f2d1-11e5-8667-31586cdaec83.png)

### ASSIGN_PHRASE

Please set phrase for team assignment. `%team` is required for assignment team name.
