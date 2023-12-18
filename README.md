# MealRoulette
![image](https://github.com/damiandomzalski/meal_roulette/assets/20732456/aecf3ff6-14e4-4b09-84a6-641c7a6982b6)


MealRoulette is a web application designed to bring spontaneity and excitement to your daily meal planning. Built with Ruby on Rails, this app allows users to generate random meal plans for every day. Integrating with a third-party API, MealRoulette offers a vast selection of recipes from cuisines worldwide, ensuring that you'll always find something new and delicious to try.

## Features

- **User Authentication**: Secure login and registration functionality to keep your meal plans personal.
- **Random Meal Generation**: Get a random meal plan for upcoming day with a single click.
- **Personalized Meal Plans**: Customize your meal plans to whatever you want to be your dinner, lunch, etc.
- **Dynamic Shopping List**: Automatically generate a shopping list based on your upcoming meal plans.
- **Recipe Management**: All chosen recipes are saved on your account, so you can find them later anytime.

## Getting Started

To get a local copy up and running, follow these simple steps:

1. Clone the repository:
   ```
   git clone https://github.com/your-username/MealRoulette.git
   ```
2. Install the required gems:
   ```
   bundle install
   ```
3. Set up the database:
   ```
   rails db:migrate
   ```
4. Start the server:
   ```
   rails server
   ```
## Future Plans

**Support for Any Day of the Week**

Currently, the application supports generating meal plans only for the next day. In the future, I plan to extend this functionality to allow users to generate meal plans for any specified day of the week.

**Integration with Tools like Google Spreadsheet**

I'm considering integrating with tools like Google Spreadsheet to send personalized shopping lists. This would allow users to easily access and manage their shopping lists from anywhere.

**Ingredient Aggregation Module**

At present, ingredients are listed in various forms such as 1/4 teaspoon, 20g, 2kg, half a cup, etc. I plan to develop a module for aggregating ingredients, which would standardize these measurements and make the shopping list more user-friendly. I'm still considering the best approach for this feature.

