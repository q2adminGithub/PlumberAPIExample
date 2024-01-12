---
output:
  pdf_document: default
  html_document: default
---
# Example: Rplumber - Built REST API

**Author - Dr. Carlos Sanz Chacon (External)**  
**Created On -  12 January 2024**

This example is based on the 4-part example from the Blog *Rplumber, Built REST API* of Jafar Aziz (`https://www.jafaraziz.com/blog/rest-api-with-r-part-1/`). Their, the reason of an API is introduced as follows:

>If you have used R, you must heard about Rshiny. Rshiny is a good tool to build data driven interactive website, like dashboard or simulation tools with R. But, for some reasons Rshiny is not good idea to choose when you need to build a service where the users access it programatically, e.g API. We use the API in another system or apps, so we can integrate our existing system with R. In example, we have developed forecasting model with R and we want use it in our exsiting app, so we must develop API with R and not a full interactive apps like Rshiny does.

This example introduces Rplumber, which is a library to make an API from R developed by RStudio. That blog deals with how to develop an API with Rplumber from routing, error handling, logging, request validation, to hosting it with docker. It has the following 4 parts:

1. Project Setup, Logging and Error Handling
2. Routing and Request Validation
3. Deploy with Docker
4. Testing and CI/CD
5. Parallel Processing and Performance

However, the source code does not include part 5.

## Installation

In order to run this example, docker is needed. Please, checkout source code

## Deploy Docker Container API

Run the following code in the project root directory in a terminal window to build only the API docker containers:

`docker-compose up --build`.

This code runs the docker-compose file 'docker-compose.yml', which starts the API service. The HTTP API can be checked by visiting the URL `http://127.0.0.1:8000/__docs__/` or via HTTP in terminal window. For instance, to test the endpoint `data/validate`` send the POST request as follows:

`curl -s -X POST 'http://localhost:8000/data/validate' \
-H 'Content-Type: application/json' \
-d '{
  "boolean": true,
  "max_number": 40,
  "number_value": 123,
  "in_array": "setosa",
  "formula": "y ~ x1 + x2",
  "number_list": [1, 2, 3, 4],
  "with_null_list": [1, null, 3, "", "hallo"],
  "data": [
    {
      "columnA": 10,
      "columnB": 20
    },
    {
      "columnA": 30,
      "columnB": 40
    }
  ]
}'`

## Run Tests on Docker Container API

It is necessary to start the the API container separated from the container, which runs the tests. Therefore, run the following code in a terminal window:

`docker compose -f "docker-compose.test.yaml" up  --abort-on-container-exit --exit-code-from test --attach test`.

## CI Pipeline

CI stands for Continuous Integration, which is a set of tasks to automate the process of building and testing software. One of the tasks in a CI process is automated testing that runs in platform like github actions, gitlab runner, or any other CI platforms as it helps ensure the changes are tested before they are released to users. Testing typically runs automatically whenever new code is committed to the repository, like github or gitlab with some scripts.

In this example the GitHub Actions script `.github/workflows/test.yml` was created, that runs the tests whenever changes are made to the repository. The following steps are performed:

1. Check out the repository
2. Build Docker image
3. Run the test using Docker Compose

The script is triggered whenever new changes to the code are committed to the repository’s master branch or when a pull request is made to the master branch.
