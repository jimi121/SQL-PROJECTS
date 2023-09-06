# DVD Rental Analysis
![image/DVD rental.jpeg](https://github.com/jimi121/SQL-PROJECTS/blob/main/DvD%20Rental%20Analysis/Image/DVD%20rental.jpeg))
# Introduction

In this project, I conducted an in-depth exploration of the  DVD Rental database. This database contains valuable information about a DVD rental company. Throughout this project, I utilized a series of queries to unearth insights into various aspects of the business. I delved into understanding customer behavior, payment earnings, and the performance of different stores within the company.

To facilitate our analysis, I harnessed the power of the DVD Rental database schema, as outlined in the `dvd-rental-erd-2.pdf` document.

# **Project Objectives and Goals**

In this project, the primary aim is to address a series of key questions that provide valuable insights into the DVD rental industry. Each question serves as a specific goal, contributing to a comprehensive understanding of the industry's performance and customer behavior. These objectives include:

1. **Genre Analysis:** Determine the most and least rented genres while also assessing their total sales, shedding light on the industry's revenue drivers.

2. **Customer Engagement:** Explore how many distinct users have engaged with each genre, indicating the diversity of customer preferences and interests.

3. **Pricing Strategy:** Analyze the average rental rate for each genre, uncovering potential correlations between pricing and rental popularity.

4. **Rental Return Patterns:** Investigate the distribution of rental film returns in terms of being early, late, or on time, allowing for insights into customer punctuality.

5. **Global Sales and Customer Base:** Examine the total sales and customer base in each country where the DVD rental industry is established, providing a holistic view of its global presence.

6. **Top Customer Recognition:** Identify the top 5 customers based on total sales and provide their detailed information, facilitating customer appreciation and retention strategies.

7. **Family Genre Insights:** Determine the most-watched movie genres among families, focusing on Animation, Children, Classics, Comedy, Family, and Music, catering to family-oriented content preferences.

8. **Store Performance:** Uncover in which months each store processed the highest total number of rental orders, aiding in staffing and inventory management.

9. **Non-Returned DVDs:** Provide details of customers who have not returned DVDs, shedding light on potential operational issues and areas for improvement.

By addressing these objectives, this project aims to offer a comprehensive and data-driven perspective on the DVD rental industry, enabling stakeholders to make informed decisions and optimize their business strategies.

## Setting Up Your Local Environment

If you're interested in replicating our analysis locally, here's a step-by-step guide to setting up your environment with PostgreSQL and the Sakila database:

**Step 1: PostgreSQL Installation**
- Begin by installing PostgreSQL on your local machine. Depending on your operating system, follow the relevant instructions:
  - For Windows: [Installation Guide](http://www.postgresqltutorial.com/install-postgresql/)
  - For macOS: [Installation Guide](https://www.postgresql.org/download/macosx/)
  
  During installation, be sure to note down the database superuser (postgres) password, as it will be necessary for creating the Sakila database.

**Step 2: Downloading the Database**
- After successfully installing PostgreSQL, proceed to download the database from this page: [PostgreSQL Sample Database](http://www.postgresqltutorial.com/postgresql-sample-database/).
- Locate the "Download DVD Rental Sample Database" button and click it. This action will download a compressed file, which you should extract to access the `dvdrental.tar` file.

**Step 3: Loading the Database**
- Now, it's time to load the DVD Rental database into your PostgreSQL server. We recommend using the PgAdmin tool for this task. Here are the detailed instructions: [Load PostgreSQL Sample Database](http://www.postgresqltutorial.com/load-postgresql-sample-database/).
- Follow the instructions provided under the section titled "Load the DVD Rental database using pgAdmin tool," and continue through the "Verify the loaded sample database."

By completing these steps, you will have successfully loaded the `dvdrental` sample database into your local PostgreSQL server.

**Step 4: Reconnecting to PostgreSQL Server**
- Relaunch the PgAdmin III application and select the PostgreSQL server within the Object browser. You will need to enter the superuser (postgres) password.

**Step 5: Connecting to the DVD Rental Database**
- In the Object browser, expand the Databases section to access the DVD rental database.

**Step 6: Choose the DVD Rental Database**
- Select the `dvdrental` database under the Databases section to establish a connection.

Congratulations, you are now linked to the DVD rental database and ready to execute SQL queries to explore the data further.

**Step 7: Running Queries**
- To run queries on your `dvdrental` database, simply click on the SQL icon featuring a magnifying glass.

With your local environment set up, you can begin exploring the DVD Rental database and uncover valuable insights. Happy querying!

![](image/dvd rental erd.png)

### Dataset Description:

I initiated the analysis by exploring the DvdRental database, which comprises 15 tables. Below, you'll find an overview of these tables along with concise descriptions:

1. **actor:** This table contains actor information, including first names and last names.

2. **film:** It includes data related to films, encompassing details like titles, release years, lengths, ratings, and more.

3. **film_actor:** This table establishes relationships between films and actors, mapping which actors are associated with each film.

4. **category:** The category table holds data regarding film categories, providing insights into the genres or classifications of films.

5. **film_category:** It serves as a bridge, linking films to their respective categories, creating associations between movies and their genres.

6. **store:** This table contains data about the DVD rental stores, encompassing details about store managers, staff, and addresses.

7. **inventory:** Inventory data is stored here, offering information about the availability of films within the stores.

8. **rental:** The rental table stores data related to rental transactions, including rental dates, film IDs, and customer IDs.

9. **payment:** Payment records of customers are stored in this table, providing information about customer payments for rentals.

10. **staff:** Staff-related data, including staff information, is stored here.

11. **customer:** This table contains data about customers, including their personal details.

12. **address:** Addresses for both staff and customers are stored in this table.

13. **city:** City names are stored in this table, providing information about the locations of addresses.

14. **country:** The country table contains data about countries, offering context for the city locations in the dataset.

This comprehensive dataset enables a thorough analysis of the DVD rental business, encompassing information about films, actors, customers,staff, and more.

## Questions to be answered:
In this project, I’ll aim to answer the following questions:

1. What are the top and least rented genres and what are their total sales?
2. Can we know how many distinct users have rented each genre ?
3. What is the average rental rate for each genre?
4. How many rental films were returned late, early and on time?
5. what are the total sales and customer base in each country where the DVD_rental industry is based?
6. who are the top 5 customers per total sales and their details?
7. What are the most-watched movie genres among families, specifically focusing on genres such as Animation, Children, Classics, Comedy, Family, and Music?
8. In which months did each store process the highest total number of rental orders?
9. Can you provide the details of customers who have not returned DVDs?


## Conclusions from the Analysis:

**Genre Diversity and Customer Preferences:**

* The DVD rental industry caters to a diverse audience, offering a wide range of 16 unique genres. This diversity is a positive sign as it accommodates various customer preferences.

**Genre Performance:**

* The sports genre stands out as the top performer, with the highest rental count and total sales revenue. It's crucial to recognize and leverage this genre's popularity for marketing and content acquisition.

* Conversely, the music genre lags behind in rentals and revenue, indicating room for improvement. Strategies to enhance the selection and promotion of music-related content could boost rentals and sales.

* Animation, action, and sci-fi genres also perform well. These genres deserve special attention for maximizing revenue potential.

* Genres like classics and music have potential for improvement. Strategies to increase their appeal, such as exclusive content or targeted marketing, could be explored.

**Consumer Behavior and Price Sensitivity:**

* Rental decisions are influenced by factors beyond the average rental rate, highlighting the significance of genre preference, content availability, and personal interests in consumer behavior.

**Store Performance:**

* The data provides a month-by-month comparison of rental order processing for two stores. It's evident that both stores experience fluctuations in rental order volumes, and understanding these patterns can inform inventory and staffing decisions.

**Customer DVD Returns:**

* The table lists customers who have not returned DVDs, primarily due to missing return dates. To address this, updating the data with return dates can help ensure timely returns.

**Overall Strategy:**

These conclusions emphasize the need for a strategic approach that considers customer preferences, genre performance, and store dynamics. Leveraging popular genres, optimizing content catalogs, and addressing missing data are all essential steps in maximizing revenue and customer satisfaction in the DVD rental industry.


## Recommendation:

**Genre Recommendations:**

* **Promote Sports Content:** Given the popularity of the sports genre, consider investing in more sports-related content, including live events, documentaries, and classic games. Create targeted marketing campaigns around major sporting events to attract sports enthusiasts.

* **Revitalize Music Category:** To improve the music genre's performance, expand the music selection, including concerts, music documentaries, and artist biopics. Implement specialized music promotions and discounts to entice customers.

* **Leverage Animation and Sci-Fi:** As animation and sci-fi genres perform well, continue to acquire high-quality content in these areas. Consider exclusive releases or themed promotions to cater to fans of these genres.

* **Revisit Classic Films:** Classics have enduring appeal. Curate a collection of timeless classics from various eras and promote them to cinephiles. Highlight the historical and artistic value of classic films in marketing campaigns.

**Consumer Behavior and Price Sensitivity:**

* **Personalized Recommendations:** Implement a recommendation system that factors in customer preferences beyond just genre. Analyze viewing history and use machine learning algorithms to suggest movies tailored to individual tastes.

**Store Performance:**

* **Inventory Management:** Based on the historical order processing data, optimize inventory management. Ensure popular genres are well-stocked during peak months, and consider offering promotions during slower periods to boost rentals.

* **Staffing Adjustments:** Align staffing levels with the expected order volumes. During peak months, hire temporary staff to handle increased demand, while scaling back during slower months to control costs.

**Customer DVD Returns:**

* **Data Integrity:** Ensure that return dates are consistently recorded for all rentals. Implement a reminder system to notify customers of upcoming return deadlines, reducing the number of late returns.

* **Late Return Policies:** Consider implementing a fair late return policy that takes into account factors beyond the customer's control, such as shipping delays. Offer incentives for on-time returns, such as discounts on future rentals.

**Overall Strategy:**

* **Customer Engagement:** Invest in customer engagement initiatives, such as loyalty programs, exclusive previews, or bonus content for repeat customers. Make it rewarding for customers to return and rent more movies.

* **Market Expansion:** Explore opportunities to expand into countries with smaller customer bases but growth potential. Tailor content offerings to suit local preferences and establish a strong online presence.

* **Analytics and Feedback:** Continuously monitor customer behavior, rental patterns, and feedback. Use data analytics to make data-driven decisions regarding content acquisition, marketing strategies, and inventory management.

* **Content Quality:** Focus on acquiring high-quality, critically acclaimed movies across genres. Quality content can drive customer satisfaction and encourage repeat business.

These recommendations aim to enhance the DVD rental industry's performance by optimizing content, improving customer engagement, and refining operational strategies to meet market demands effectively.
