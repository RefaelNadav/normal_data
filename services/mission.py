
import psycopg2
from db import get_db_connection, release_db_connection


def get_all_missions():
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        query = """
        SELECT *
        FROM mission
        LIMIT 10;
        """
        cur.execute(query)
        missions = cur.fetchall()
        return True, missions
    except psycopg2.Error as e:
        print(e)
        return False
    finally:
        if cur:
            cur.close()
        release_db_connection(conn)