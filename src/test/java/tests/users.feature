Feature: 'Karate demo tests'

  Background:
    * url 'https://reqres.in/api'

  Scenario: GET, LIST USERS
    Given path '/users'
    And param page = 2
    When method GET
    Then status 200
    And def user = get[0] response.data[?(@.id==11)]
    And match user.id == 11
    And match user.email == 'george.edwards@reqres.in'
    And match user.first_name == 'George'
    And match user.last_name == 'Edwards'
    And match user.avatar == 'https://reqres.in/img/faces/11-image.jpg'


 Scenario Outline: GET, SINGLE USER
    Given path '/users'
    And def userId = <userId>
    And path '/' + userId
    When method GET
    Then status 200
    And def user = response.data
    And match user.email == <email>
    And match user.first_name == <firstName>
    And match user.last_name == <last_name>
    And match user.avatar == <avatar>
    And match response.support != null

    Examples:
      |userId|email|firstName|last_name|avatar|
      |11|'george.edwards@reqres.in'|'George' |'Edwards'|'https://reqres.in/img/faces/11-image.jpg'|

  Scenario: POST, CREATE
    Given path '/users'
    And def newRequest = read("../resources/createRequest.json")
    And request newRequest
    When method POST
    Then status 201
    And print response
    And match response.name == 'morpheus'
    And match response.job == 'leader'
    And match response.id != null
    And match response.createdAt != null

  Scenario Outline: POST, REGISTER – UNSUCCESSFUL
    Given path '/register'
    And request { email: <email> }
    When method POST
    Then status 400
    And print response
    And match response.error == <error>

    Examples:
    |email|error|
    |'sydney@fife'|'Missing password'|

  Scenario Outline: GET, LIST USERS + GET, SINGLE USER
    Given path '/users'
    And param page = 2
    When method GET
    Then status 200
    And print response
    And def userOnList = get[0] response.data[?(@.id==<userId>)]
    Given path '/users'
    And path '/' + <userId>
    When method GET
    Then status 200
    And print response
    And def singleUser = response.data
    And match userOnList.id == singleUser.id
    And match userOnList.email == singleUser.email
    And match userOnList.first_name == singleUser.first_name
    And match userOnList.last_name == singleUser.last_name
    And match userOnList.avatar == singleUser.avatar


    Examples:
    |userId|
    |11|
