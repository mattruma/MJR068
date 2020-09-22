const core = require('@actions/core');
const github = require('@actions/github');

console.log(github.context.payload.issue);

// https://octokit.github.io/rest.js/v18

const octokit = new github.GitHub(core.getInput('token'));

const issue_number = core.getInput('issue_number');

const response = octokit.issues.update({
    ...github.context.repo,
    issue_number,
    state: 'closed'
})

core.setOutput('issue', JSON.stringify(response.data));