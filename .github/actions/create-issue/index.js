const core = require('@actions/core');
const github = require('@actions/github');

const octokit = new github.GitHub(core.getInput('token'));

// https://octokit.github.io/rest.js/v18

const title = core.getInput('title');
const body = core.getInput('body');
const assignees = core.getInput('assignees');
const labels = core.getInput('labels');

const response = octokit.issues.create({
    ...github.context.repo,
    title,
    body,
    assignees: assignees ? assignees.split(',') : undefined,
    labels: labels ? labels.split(',') : undefined
})

core.setOutput('issue', JSON.stringify(response.data));