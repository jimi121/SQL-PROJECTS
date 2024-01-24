DROP TABLE IF EXISTS album;
CREATE TABLE album
(
    album_id character varying(30) NOT NULL,
    title character varying(150),
    artist_id character varying(30),
    PRIMARY KEY (album_id)

);

DROP TABLE IF EXISTS artist;
CREATE TABLE artist
(
    artist_id character varying(30) NOT NULL,
    name character varying(150),
    PRIMARY KEY (artist_id)

);

DROP TABLE IF EXISTS customer;
CREATE TABLE customer
(
    customer_id character varying(30) NOT NULL,
    first_name character(30),
    last_name character(30),
    company character varying(150),
    address character varying(250),
    city character varying(30),
    state character varying(30),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30),
    support_rep_id character varying(30),
    PRIMARY KEY (customer_id)

);

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(
    employee_id character varying(30) NOT NULL,
    last_name character(50),
    first_name character(50),
    title character varying(250),
    reports_to character varying(30),
    levels character varying(10),
    birth_date timestamp without time zone,
    hire_date timestamp without time zone,
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30),
    PRIMARY KEY (employee_id)

);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre
(
    genre_id character varying(30) NOT NULL,
    name character varying(50),
    PRIMARY KEY (genre_id)

);

DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice
(
    invoice_id character varying(30) NOT NULL,
    customer_id character varying(30),
    invoice_date timestamp without time zone,
    billing_address character varying(120),
    billing_city character varying(30),
    billing_state character varying(30),
    billing_country character varying(30),
    billing_postal character varying(30),
    total double precision,
    PRIMARY KEY (invoice_id)

);

DROP TABLE IF EXISTS invoice_line;
CREATE TABLE invoice_line
(
    invoice_line_id character varying(30) NOT NULL,
    invoice_id character varying(30),
    track_id character varying(30),
    unit_price numeric,
    quantity integer,
    PRIMARY KEY (invoice_line_id)

);

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type
(
    media_type_id character varying(30) NOT NULL,
    name character varying(30),
    PRIMARY KEY (media_type_id)

);

DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist
(
    playlist_id character varying(30) NOT NULL,
    name character varying(50),
    PRIMARY KEY (playlist_id)

);

DROP TABLE IF EXISTS playlist_track;
CREATE TABLE playlist_track
(
    playlist_id character varying(30),
    track_id character varying(50)

);

DROP TABLE IF EXISTS track;
CREATE TABLE track
(
    track_id character varying(30) NOT NULL,
    name character varying(250),
    album_id character varying(30),
    media_type_id character varying(30),
    genre_id character varying(30),
    composer character varying(250),
    milliseconds bigint,
    bytes integer,
    unit_price numeric,
    PRIMARY KEY (track_id)

);

ALTER TABLE album
    ADD FOREIGN KEY (artist_id)
    REFERENCES artist (artist_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE customer
    ADD FOREIGN KEY (support_rep_id)
    REFERENCES employee (employee_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE employee
--DROP CONSTRAINT employee_reports_to_fkey;
    ADD FOREIGN KEY (reports_to)
    REFERENCES employee (employee_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE invoice
    ADD FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE invoice_line
    ADD FOREIGN KEY (invoice_id)
    REFERENCES invoice (invoice_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE invoice_line
    ADD FOREIGN KEY (track_id)
    REFERENCES track (track_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE playlist_track
    ADD FOREIGN KEY (playlist_id)
    REFERENCES playlist (playlist_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE playlist_track
    ADD FOREIGN KEY (track_id)
    REFERENCES track (track_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE track
    ADD FOREIGN KEY (album_id)
    REFERENCES album (album_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE track
    ADD FOREIGN KEY (genre_id)
    REFERENCES genre (genre_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE track
    ADD FOREIGN KEY (media_type_id)
    REFERENCES media_type (media_type_id)
    ON DELETE CASCADE
    NOT VALID;
