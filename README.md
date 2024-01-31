# README

# ASSIGNMENT

# How to Run the Test Job
* Clone the repository to your local machine.
  git clone https://github.com/Gouravsen7/file_upload_rails.git
## Stack
- Ruby 3.0.0
- Rails 7.1.3
- Postgres '~> 1.5', '>= 1.5.4'
* Install Dependencies:
  - bundle install
* Database Setup:
  - Setup databsase.yml file if database requires password to access.
  - Create the database: bundle exec rails db:create
  - Migrate the database: bundle exec rails db:migrate
  - Seed the database: bundle exec rails db:seed
* Run the Application:
 - Start the server: rails server

* Log in to your account.
  User credentials:

  Email: user1@yopmail.com
  Password: Test@123

* Postman Collection URL:
 https://api.postman.com/collections/26622774-c4afe27f-01c3-4209-af65-1095fcd6025f?access_key=PMAT-01HNDH1CXTA8M8A2P95ZHRY2G5

* Postman JSON:
==========================================================================================
{
  "info": {
    "_postman_id": "fde6bf8a-8042-401c-94ce-6149108b1f18",
    "name": "test_job",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "login_user",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\n    \"email\": \"user1@yopmail.com\",\n    \"password\": \"Test@123\"\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "{{local}}/login",
          "host": [
            "{{local}}"
          ],
          "path": [
            "login"
          ]
        }
      },
      "response": []
    },
    {
      "name": "upload data in single csv (hole)",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "token",
            "value": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE3MDcyODYwMDF9.r4WhWURCjZiRON6EImF3ObApfCJ77RJKwQPS3Cqs28U",
            "type": "text"
          }
        ],
        "body": {
          "mode": "formdata",
          "formdata": [
            {
              "key": "file",
              "type": "file",
              "src": "/home/acer/Desktop/gourav_sir_project/test/test.csv"
            }
          ]
        },
        "url": {
          "raw": "{{local}}/file_upload",
          "host": [
            "{{local}}"
          ],
          "path": [
            "file_upload"
          ]
        }
      },
      "response": []
    },
    {
      "name": "hole details",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "token",
            "value": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE3MDcyODYwMDF9.r4WhWURCjZiRON6EImF3ObApfCJ77RJKwQPS3Cqs28U",
            "type": "text"
          }
        ],
        "body": {
          "mode": "formdata",
          "formdata": [
            {
              "key": "file",
              "type": "file",
              "src": "/home/acer/Desktop/gourav_sir_project/test/FA653EE7.csv"
            },
            {
              "key": "",
              "value": "",
              "type": "text",
              "disabled": true
            }
          ]
        },
        "url": {
          "raw": "{{local}}/data_visualization",
          "host": [
            "{{local}}"
          ],
          "path": [
            "data_visualization"
          ]
        }
      },
      "response": []
    },
    {
      "name": "listing hotel details",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "token",
            "value": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE3MDcyODYwMDF9.r4WhWURCjZiRON6EImF3ObApfCJ77RJKwQPS3Cqs28U",
            "type": "text"
          }
        ],
        "url": {
          "raw": "{{local}}/data_visualization?page=2",
          "host": [
            "{{local}}"
          ],
          "path": [
            "data_visualization"
          ],
          "query": [
            {
              "key": "page",
              "value": "2"
            }
          ]
        }
      },
      "response": []
    },
    {
      "name": "logout_user",
      "request": {
        "method": "DELETE",
        "header": [
          {
            "key": "token",
            "value": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MDcxNDQ5Mjl9.y5oX5Eldt1XXmU8GMEroC9LWVFicE-EJ5yWbPU1vXVA",
            "type": "text"
          }
        ],
        "url": {
          "raw": "{{local}}/logout",
          "host": [
            "{{local}}"
          ],
          "path": [
            "logout"
          ]
        }
      },
      "response": []
    }
  ]
}
====================================================================================================================