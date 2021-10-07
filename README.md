# Restorev
A production quality, non-trivial, collection of educational projects on various platforms.

## Requirements

A role-based restaurant manager application where 

- regular users can view and rate restaurants
- restaurant owners can create and manage their restaurants
- admins who can manage users and restaurants

### Informal stories

- A user must be able to create an account and log in. When they sign up, they sign up as regular users. 

- There can be 3 different roles in the system of various permission levels: 

  - a Regular User who should be able rate and leave a comment for a restaurant.
  - an Owner who can create restaurants and reply to comments about owner restaurants.
  - an Admin who can edit/delete all users, restaurants, commments and reviews.
  
- There must an admin already present in the system. 

- A user can be an owner, or an admin or a owner at any given point.

- Reviews should have: 
  - a 5 star-based rating.
  - date of visit.
  - review text.

- When any user is deleted, all the reviews made by them should get deleted. 

- When a Regular User logs in, they will see a restaurant list ordered by average rating.

- When an Owner logs in, they will see a restaurant list - only the ones owned by them, and the reviews pending reply.

- When a user taps on a restaurant, it should take the user to the restaurant detail screen.

- Restaurants detailed view should have:

    - the overall average rating.
    - the highest rated review.
    - the lowest rated review.
    - last reviews with rate, comment, and reply.
    
- An Owner can reply to each review once.

- Restaurant list can be filtered by rating.

- There should be a possible way to perform all user actions via the API, including authentication.

- There should be a way to explain how a REST API works and demonstrate that by creating functional tests that use the REST Layer directly.

## Design

The UI/UX design for the entire application can be found [here](https://scene.zeplin.io/project/60fbf0795231ef10efd6441a). 

## Backend Setup

You might need to get the backend up and running for this task; to do so: 

1. Install node
2. `cd <download_path>/backend`
3. `npm install`
4. `npm start`

The server should be up and running locally on port `3001`
