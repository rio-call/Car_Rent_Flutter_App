# Car Rental 

## What this project is
This is a Flutter car rental application. A user can create an account, sign in, browse cars, open details, and submit a booking. There is also an admin panel that can manage cars and bookings.

The app uses Firebase for login and data storage, and it can show a car location on a map (when the car has latitude/longitude saved).

## What you can do in the app
- Sign up / sign in using email and password
- Browse cars (lists and sections on the home screen)
- Open a car details page
- Submit a booking with start/end dates
- See booking status (example statuses: pending, approved, rejected)
- Admin features:
  - Add/edit/delete cars
  - Review bookings and update booking status
- Contact Us page:
  - Send a message by email (SMTP)

### ------------------ Main libraries (packages) used ----------------- ###


### Flutter UI
- flutter: the main framework
- google_nav_bar: bottom navigation bar UI
### Firebase (backend)
- firebase_core: initializes Firebase in the app
- firebase_auth: authentication (login/register) and auth state stream
- firebase_database: Firebase Realtime Database (cars and bookings data)

### Maps
- mapbox_maps_flutter: displays a Mapbox map and annotations for showing a car location

### Email / Contact Us
- mailer: sends email using SMTP (used by the Contact Us form)


### Dev / tooling
- flutter_launcher_icons: generates launcher icons

### ------------------ Main libraries (packages) used ----------------- ###
## Project structure 
- lib/main.dart
  - App entry point
  - Initializes Firebase
  - Sets Mapbox access token
  - Decides what screen to show based on login state
- lib/authAndAdmin/
  - Welcome screen, auth screen, and admin panel screens
- lib/screens/
  - User screens (home, booking, details, etc.)
- lib/services/
  - App logic and integrations (auth, database repositories, email service)
- lib/models/
  - Data models like Car and Booking
- assets/images/
  - Images used by the UI

## Data model notes (Firebase Realtime Database)
The app reads/writes data in nodes like:
- cars: car info (make, model, year, price per day, optional latitude/longitude, etc.)
- bookings: booking info (userId, carId, dates, total price, status, etc.)

## How the app decides what to show (login flow)
- If the user is NOT logged in: show the welcome/auth screens
- If the user IS logged in: show the home screen

## Note about secrets 
Some tokens/credentials are currently inside the code (like Mapbox token and SMTP email settings). This is okay for a learning project, but in a real project you should not commit secrets into source code. They should be stored in a safer place (configuration, environment variables, or a backend).

## By Abdalrouf && Anas && Assel
