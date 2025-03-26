# Lab 8

## How to use the starter code
1. Accept the assignment from GitHub Classroom.
2. Create a new project in Vivado.
3. In the terminal, navigate to your project directory. This should be something like `/home/<user>/Lab8`.
4. Initialize a git repository in this directory with `git init --initial-branch=main`
5. Set the origin with `git remote add origin <url-to-git-repo>`. Make sure to use the ssh url. If this is the first time using the starter code on your virtual machine, you'll need to add a new SSH key to your GitHub account. Instructions can be found [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux).
6. Pull the starter code to your project with `git pull origin main`. Now the starter code is in your project directory. Note: It is important to pull the starter code before you start working on the lab to avoid merge conflicts!
7. To add starter files to your Vivado project, go to *Add Sources -> Add Files,* and find your project directory. Now you can select the files you would like to add to your Vivado project.  **NOTE: Be sure to check the box next to *Copy source into project,* so that a new copy of that file is created in the project's folder hierarchy where Vivado stores such source files.**

## How to submit
1. Add any screenshots or images to the `submissions` directory. Be sure to name the images the way they are specified in the lab write-up. You do not need to copy any `.sv` files in this directory; they will be submitted by `git` from their locations within the Vivado project folder hierarchy.
2. Type answers to any questions in `submissions/README.md`
3. Use `git add .` to stage your changes, then commit.
4. Log in to Gradescope and connect your repository to the assignment.