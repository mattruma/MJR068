const core = require('@actions/core');
const github = require('@actions/github');

console.log(github.context.payload.issue);

core.setOutput(
    "exists",
    github.context.payload.issue.labels
        .some((label) => label.name === core.getInput('label'))
        .toString()
);