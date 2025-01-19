# tidyBYTE Cafe Database Project

## Introduction

This is a personal project with the intention of putting some SQL techniques into practice. My main focus was making queries that use UNION, JOIN, SUBQUERIES, CTE, and aggregated functions to get better at them, understanding the specificity that comes with some of the requirements.

Then, I constructed some tables that I could import into Tableau to make two dashboards that visualize the data. By trying to make a bit more effort into the visuals as my learning of Tableau has risen a bit, I've attempted to make a visually aesthetic story comprising of two dashboards and an introductory page.

## Tableau Story

Check out the Tableau story visualizing this data [here](https://public.tableau.com/shared/Y6CTTWYMC?:display_count=n&:origin=viz_share_link).

## Scenario

Gunther Smith came to Australia to open a cafe, seeking a change from his successful site in America. He established tidyBYTE Cafe in a busy area in Sydney, creating a 37-item menu. The menu includes various coffee styles and sizes, along with several addons, two sandwich items, and three biscuits to choose from.

Gunther provided all the ingredient details, including measurements and recipes, and requested the construction of a database to capture sales data for future analysis.

## Part 1: Database Setup

- **Suppliers Table**: Stores supplier information.
- **Ingredients Table**: Captures ingredient details and costs.
- **Staff Table**: Manages staff information and hourly rates.
- **Transactions Table**: Records transaction details, including date, time, staff, and amount.
- **Item Table**: Stores menu items, including names, prices, and categories.
- **Recipe Table**: Links items with their ingredients.
- **Inventory Table**: Manages inventory levels of each ingredient.
- **Transaction_Items Table**: Captures sold items per transaction.

Taking into consideration appropriate naming conventions, foreign keys, and overall design, I've used ChartDB to help visualize and connect the dots for the database setup before writing it out. Below, you'll find an image illustrating this setup.

![image_alt](https://github.com/PortelliA/TidyBYTE-Cafe---SQL---Tableau/blob/bfeb47146e2cc34ddcc861927aa8d34a8c50766d/Screenshot%202025-01-20%20082140.png)

## Part 2: Data Input

Following the database setup, I inputted existing information regarding ingredients, menu items, and initial transaction data. This formed the foundation for capturing and storing sales data for future analysis.

## Part 3: Sales Performance Analysis

**Overview:**
- Total sales include 94,144 items sold across 56,040 transactions.
- The average basket size is approximately 1.68 items per transaction.

**Peak Sales Periods:**
- **Thursday** is the busiest day of the week.
- The busiest hour during the day is from **11:00 AM to 12:00 PM**.

**Top Revenue and Profit Generators:**
1. **Toasted Chicken Teriyaki Sandwich**
   - Total Revenue: $48,868.00
   - Profit: $25,447.30
2. **Cheese and Tomato Sandwich**
   - Total Revenue: $47,151.00
   - Profit: $24,185.15

**High-Profit Percentage Items:**
1. **Caramel Syrup Add-on**
   - Profit %: 97.56%
2. **Almond Syrup Add-on**
   - Profit %: 97.58%

## Coffee Orders Summary

*The following figures are the accumulation of all different styles of coffee and their two size options. The profit figures should not be confused with the highest individual contribution compared to sandwiches.*

**Coffee Orders Breakdown:**
- **Total Almond Milk Orders**: 14,763
   - Total Profit: $54,854.71
- **Total Oat Milk Orders**: 14,576
   - Total Profit: $54,242.54
- **Total Other Coffee Orders**: 45,792
   - Total Profit: $146,834.03

## Challenges & Recommendations

**Issues:**
- Saturdays show slower sales compared to other days of the week, operating at a 1.5x pay rate for the casual and part-time staff. Impacting overall revenue.

**Potential Solutions for Enhancing Saturday Sales:**
1. **Promotional Campaigns**: Special discounts, deals, or loyalty rewards exclusive to Saturdays.
2. **Marketing Initiatives**: Set up social media and email marketing, where Saturday-specific offers and events could be shared.
3. **Menu Revamp**: With such a high profit margin coming from Syrups. Consider adding additional items that incorporate the syrups. These potential recipes could be trialed exclusively on Saturdays, being a slower day. With a bit of advertisement, this could be a way to determine if the new items have a positive impact while not affecting the main trade.

## Conclusion

Thursdays and mid-mornings experience high sales volume, whereas Saturdays represent an opportunity for growth. Targeting future strategies to boost Saturday revenue, ensuring a more balanced and profitable weekly performance. Additionally, almond and oat milk coffee varieties contribute significantly to sales, while specialty sandwiches and high-margin syrup add-ons drive high revenue and profit.


## Files Included

- Script to build the database
- Input values for the database
- Two transaction files
- Queries used to make the story in Tableau

---

Thank you for reviewing the tidyBYTE Cafe Database Project. All data used was fabricated, feel free to use for your own means.
