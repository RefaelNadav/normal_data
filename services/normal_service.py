
from db import get_db_connection
import psycopg2

def normalize_db():
    source_conn = get_db_connection()
    target_conn = psycopg2.connect(
        dbname="normal_mission_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

    try :
        print("test1")
        query6 = """
            CREATE TABLE target_details (
                                target_id INT,
                                target_priority INT,
                                location_id INT REFERENCES target_location(location_id),
                                type_id INT REFERENCES target_types(type_id),
                                industry_id INT REFERENCES industries(industry_id)
            )
            """

        query3 = """
            CREATE TABLE countries (
                           country_id SERIAL PRIMARY KEY,
                           country_name VARCHAR(255) UNIQUE
        )
        """

        query5 = """
        CREATE TABLE target_location (
                                 location_id SERIAL PRIMARY KEY,
                                 target_latitude NUMERIC(10, 6),
                                 target_longitude NUMERIC(10, 6),
                                 city_id INT REFERENCES cities(city_id)
        )
        """

        query4 = """
        CREATE TABLE cities (
                        city_id SERIAL PRIMARY KEY,
                        city_name VARCHAR(255) UNIQUE,
                        country_id INT REFERENCES countries(country_id)
        )
        """

        query2 = """
        CREATE TABLE target_types (
                              type_id SERIAL PRIMARY KEY,
                              type_name VARCHAR(255) UNIQUE
        )
        """

        query1 = """
        CREATE TABLE industries (
                            industry_id SERIAL PRIMARY KEY,
                            industry_name VARCHAR(255)
        )
        """
        print("test2")
        # Execute multiple queries one by one
        cur = target_conn.cursor()
        print("test3")
        queries = [query1, query2, query3, query4, query5, query6]
        # for query in queries:
        #     print("test4")
        #     cur.execute(query)
        #     print("test5")
        #     print(f"{query} succcess")
        # target_conn.commit()

        s_cur = source_conn.cursor()
        s_cur.execute("SELECT * FROM mission LIMIT 20")
        while True:
            mission_row = s_cur.fetchone()
            if mission_row is None:
                break



            try:
                target_country = mission_row[14]
                cur.execute("""
                    INSERT INTO countries (country_name) 
                    VALUES (%s) 
                    RETURNING country_id
                    """,
                            (target_country,))

                country_id = cur.fetchone()
                # country is unique
                if country_id is None:
                    cur.execute("SELECT country_id FROM countries WHERE country_name = %s", (target_country,))
                    country_id = cur.fetchone()[0]
                else:
                    country_id = country_id[0]

                target_city = mission_row[15]
                cur.execute("""
                    INSERT INTO cities (city_name, country_id) 
                    VALUES (%s, %s) 
                    RETURNING city_id
                    """,
                            (target_city, country_id))

                city_id = cur.fetchone()
                if city_id is None:
                    cur.execute("SELECT city_id FROM cities WHERE city_name = %s AND country_id = %s",
                                (target_city, country_id))
                    city_id = cur.fetchone()[0]
                else:
                    city_id = city_id[0]

                target_latitude = mission_row[19]
                target_longitude = mission_row[20]
                cur.execute("""
                    INSERT INTO target_location (target_latitude, target_longitude, city_id) 
                    VALUES (%s, %s, %s) 
                    RETURNING location_id
                    """,
                            (target_latitude, target_longitude, city_id))

                location_id = cur.fetchone()[0]

                target_type = mission_row[16]
                cur.execute("""
                    INSERT INTO target_types (type_name) 
                    VALUES (%s)  
                    RETURNING type_id
                    """,
                            (target_type,))

                type_id = cur.fetchone()
                if type_id is None:
                    cur.execute("SELECT type_id FROM target_types WHERE type_name = %s", (target_type,))
                    type_id = cur.fetchone()[0]
                else:
                    type_id = type_id[0]

                target_industry = mission_row[17]
                cur.execute("""
                                    INSERT INTO industries (industry_name) 
                                    VALUES (%s) 
                                    RETURNING industry_id
                                    """,
                            (target_industry,))

                industry_id = cur.fetchone()
                if industry_id is None:
                    cur.execute("SELECT industry_id FROM industries WHERE industry_name = %s", (target_industry,))
                    industry_id = cur.fetchone()[0]
                else:
                    industry_id = industry_id[0]

                target_id = mission_row[13]
                target_priority = mission_row[18]


                cur.execute("""
                    INSERT INTO target_details (target_id, target_priority, location_id, type_id, industry_id) 
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                            (target_id, target_priority, location_id, type_id, target_industry))

                target_conn.commit()

            except Exception as e:
                print("Error occurred 1:", e)
                target_conn.rollback()



    except Exception as e:
        print("Error occurred2:", e)
    finally:
        cur.close()
        target_conn.close()



result = normalize_db()
