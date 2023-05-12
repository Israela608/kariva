# Kariva - Food Delivery / E-commerce App

Kariva is a mobile application built using Flutter that serves as a platform for food delivery and e-commerce. It features more than 20 screens and includes major features such as a shopping cart, place order, track order, user profile, sign in and sign up, user address location from Google Maps, zone-based order, user authentication, Firebase notification, PayPal payment integration, see order details, and update order status. The app is connected to a Laravel backend through REST API, which was built by the developer.

## Screenshots

Here are some screenshots of the app:

## Features

#### Show Products Based on Category
Kariva allows users to browse and search for products based on category. Users can view products and their details, including images, prices, and descriptions.

#### Shopping Cart
The app includes a shopping cart that allows users to add items to their cart and view the total cost. They can also modify or remove items from the cart.

#### Place Order
Users can place an order after adding items to their cart. They can select a delivery location and choose from available payment methods.

#### Track Order
The app includes a tracking feature that allows users to track the status of their order.

#### User Profile
Kariva includes a user profile section that displays a user's personal information and order history.

#### Sign In and Sign Up
Users can sign in to the app using their email and password. They can also create a new account by providing their personal information and email address.

#### User Address Location from Google Map
The app uses Google Maps to enable users to choose a delivery location by searching for an address or dropping a pin on the map.

#### Zone-Based Order
Kariva offers zone-based ordering, which means that users can only place orders within a specific geographic area.

#### User Authentication
The app uses user authentication to ensure that only authorized users can access their account and place orders.

#### Firebase Notification
The app is integrated with Firebase notification to provide users with real-time updates on their orders.

#### PayPal Payment Integration
Kariva includes PayPal payment integration, which allows users to pay for their orders using PayPal.

#### See Order Details
Users can view the details of their order, including items, prices, and delivery details.


## State Management
Kariva uses GetX for state management, routing, and dependency injection. GetX is a lightweight and powerful framework that simplifies the development of Flutter applications.

## Backend
The app is connected to a Laravel backend through REST API. The backend was also built by the developer and includes features such as product management, order management, and user management. The GitHub link to the backend can be found here: INSERT LINK HERE.

## Setting Up the Backend
- Install XAMPP, Composer, and PHPMyAdmin on your local machine.

- Clone the backend repository from GitHub to your machine.

- Open the XAMPP control panel and start the Apache and MySQL modules.

- Open PHPMyAdmin in your browser and create a new database called kariva.

- Import the SQL file provided in the database directory of the backend repository to create the necessary tables.

- Navigate to the backend repository in your terminal and run composer install to install the necessary packages.

- Start the Laravel development server by running php artisan serve.

- Note the IP address and port number of your local machine.

## Setting Up the App

- Clone the app repository from GitHub to your machine.

- Open the project in your code editor.

- Start the backend server by hosting it on your local machine using XAMPP, Composer, and PHPMyAdmin.

- Update the lib/utils/constants.dart file with your local machine's IP address:  
  ##### const String BASE_API_URL = "http://YOUR_LOCAL_MACHINE_IP_ADDRESS/Kariva-backend/public/api";

- Run the application using the flutter run command.

## Conclusion

Kariva is a comprehensive and robust food delivery and e-commerce application that offers a range of features for users. It was built using Flutter and GetX for state management, routing, and dependency injection. The app is connected to a Laravel backend through REST API and features Firebase