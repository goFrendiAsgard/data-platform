--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    topic character varying(32) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer,
    model character varying(16),
    model_id integer,
    database_id integer,
    table_id integer,
    custom_id character varying(48),
    details character varying NOT NULL
);


ALTER TABLE public.activity OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_id_seq OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: card_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card_label (
    id integer NOT NULL,
    card_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.card_label OWNER TO postgres;

--
-- Name: card_label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.card_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.card_label_id_seq OWNER TO postgres;

--
-- Name: card_label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.card_label_id_seq OWNED BY public.card_label.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    color character(7) NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    location character varying(254) DEFAULT '/'::character varying NOT NULL,
    personal_owner_id integer,
    slug character varying(254) NOT NULL
);


ALTER TABLE public.collection OWNER TO postgres;

--
-- Name: TABLE collection; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.collection IS 'Collections are an optional way to organize Cards and handle permissions for them.';


--
-- Name: COLUMN collection.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.name IS 'The user-facing name of this Collection.';


--
-- Name: COLUMN collection.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.description IS 'Optional description for this Collection.';


--
-- Name: COLUMN collection.color; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.color IS 'Seven-character hex color for this Collection, including the preceding hash sign.';


--
-- Name: COLUMN collection.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.archived IS 'Whether this Collection has been archived and should be hidden from users.';


--
-- Name: COLUMN collection.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.location IS 'Directory-structure path of ancestor Collections. e.g. "/1/2/" means our Parent is Collection 2, and their parent is Collection 1.';


--
-- Name: COLUMN collection.personal_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.personal_owner_id IS 'If set, this Collection is a personal Collection, for exclusive use of the User with this ID.';


--
-- Name: COLUMN collection.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.slug IS 'Sluggified version of the Collection name. Used only for display purposes in URL; not unique or indexed.';


--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_id_seq OWNER TO postgres;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: collection_revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.collection_revision OWNER TO postgres;

--
-- Name: TABLE collection_revision; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.collection_revision IS 'Used to keep track of changes made to collections.';


--
-- Name: COLUMN collection_revision.before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_revision.before IS 'Serialized JSON of the collections graph before the changes.';


--
-- Name: COLUMN collection_revision.after; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_revision.after IS 'Serialized JSON of the collections graph after the changes.';


--
-- Name: COLUMN collection_revision.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN collection_revision.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN collection_revision.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: collection_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_revision_id_seq OWNER TO postgres;

--
-- Name: collection_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_revision_id_seq OWNED BY public.collection_revision.id;


--
-- Name: computation_job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computation_job (
    id integer NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(254) NOT NULL,
    status character varying(254) NOT NULL,
    context text,
    ended_at timestamp without time zone
);


ALTER TABLE public.computation_job OWNER TO postgres;

--
-- Name: TABLE computation_job; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.computation_job IS 'Stores submitted async computation jobs.';


--
-- Name: computation_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computation_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_id_seq OWNER TO postgres;

--
-- Name: computation_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computation_job_id_seq OWNED BY public.computation_job.id;


--
-- Name: computation_job_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computation_job_result (
    id integer NOT NULL,
    job_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permanence character varying(254) NOT NULL,
    payload text NOT NULL
);


ALTER TABLE public.computation_job_result OWNER TO postgres;

--
-- Name: TABLE computation_job_result; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.computation_job_result IS 'Stores results of async computation jobs.';


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computation_job_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_result_id_seq OWNER TO postgres;

--
-- Name: computation_job_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computation_job_result_id_seq OWNED BY public.computation_job_result.id;


--
-- Name: core_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_session (
    id character varying(254) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.core_session OWNER TO postgres;

--
-- Name: core_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_user (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    first_name character varying(254) NOT NULL,
    last_name character varying(254) NOT NULL,
    password character varying(254) NOT NULL,
    password_salt character varying(254) DEFAULT 'default'::character varying NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    is_active boolean NOT NULL,
    reset_token character varying(254),
    reset_triggered bigint,
    is_qbnewb boolean DEFAULT true NOT NULL,
    google_auth boolean DEFAULT false NOT NULL,
    ldap_auth boolean DEFAULT false NOT NULL,
    login_attributes text,
    updated_at timestamp without time zone
);


ALTER TABLE public.core_user OWNER TO postgres;

--
-- Name: COLUMN core_user.login_attributes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.login_attributes IS 'JSON serialized map with attributes used for row level permissions';


--
-- Name: COLUMN core_user.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.updated_at IS 'When was this User last updated?';


--
-- Name: core_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_id_seq OWNER TO postgres;

--
-- Name: core_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_user_id_seq OWNED BY public.core_user.id;


--
-- Name: dashboard_favorite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_favorite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.dashboard_favorite OWNER TO postgres;

--
-- Name: TABLE dashboard_favorite; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dashboard_favorite IS 'Presence of a row here indicates a given User has favorited a given Dashboard.';


--
-- Name: COLUMN dashboard_favorite.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dashboard_favorite.user_id IS 'ID of the User who favorited the Dashboard.';


--
-- Name: COLUMN dashboard_favorite.dashboard_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dashboard_favorite.dashboard_id IS 'ID of the Dashboard favorited by the User.';


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboard_favorite_id_seq OWNER TO postgres;

--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_favorite_id_seq OWNED BY public.dashboard_favorite.id;


--
-- Name: dashboardcard_series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboardcard_series (
    id integer NOT NULL,
    dashboardcard_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.dashboardcard_series OWNER TO postgres;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboardcard_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboardcard_series_id_seq OWNER TO postgres;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboardcard_series_id_seq OWNED BY public.dashboardcard_series.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_migrations (
    id character varying(254) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public.data_migrations OWNER TO postgres;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- Name: dependency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dependency (
    id integer NOT NULL,
    model character varying(32) NOT NULL,
    model_id integer NOT NULL,
    dependent_on_model character varying(32) NOT NULL,
    dependent_on_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dependency OWNER TO postgres;

--
-- Name: dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dependency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dependency_id_seq OWNER TO postgres;

--
-- Name: dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dependency_id_seq OWNED BY public.dependency.id;


--
-- Name: dimension; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dimension (
    id integer NOT NULL,
    field_id integer NOT NULL,
    name character varying(254) NOT NULL,
    type character varying(254) NOT NULL,
    human_readable_field_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.dimension OWNER TO postgres;

--
-- Name: TABLE dimension; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dimension IS 'Stores references to alternate views of existing fields, such as remapping an integer to a description, like an enum';


--
-- Name: COLUMN dimension.field_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.field_id IS 'ID of the field this dimension row applies to';


--
-- Name: COLUMN dimension.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.name IS 'Short description used as the display name of this new column';


--
-- Name: COLUMN dimension.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.type IS 'Either internal for a user defined remapping or external for a foreign key based remapping';


--
-- Name: COLUMN dimension.human_readable_field_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.human_readable_field_id IS 'Only used with external type remappings. Indicates which field on the FK related table to use for display';


--
-- Name: COLUMN dimension.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.created_at IS 'The timestamp of when the dimension was created.';


--
-- Name: COLUMN dimension.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.updated_at IS 'The timestamp of when these dimension was last updated.';


--
-- Name: dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dimension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dimension_id_seq OWNER TO postgres;

--
-- Name: dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dimension_id_seq OWNED BY public.dimension.id;


--
-- Name: label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.label (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    slug character varying(254) NOT NULL,
    icon character varying(128)
);


ALTER TABLE public.label OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.label_id_seq OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.label_id_seq OWNED BY public.label.id;


--
-- Name: metabase_database; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_database (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    details text,
    engine character varying(254) NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_full_sync boolean DEFAULT true NOT NULL,
    points_of_interest text,
    caveats text,
    metadata_sync_schedule character varying(254) DEFAULT '0 50 * * * ? *'::character varying NOT NULL,
    cache_field_values_schedule character varying(254) DEFAULT '0 50 0 * * ? *'::character varying NOT NULL,
    timezone character varying(254),
    is_on_demand boolean DEFAULT false NOT NULL,
    options text,
    auto_run_queries boolean DEFAULT true NOT NULL
);


ALTER TABLE public.metabase_database OWNER TO postgres;

--
-- Name: COLUMN metabase_database.metadata_sync_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.metadata_sync_schedule IS 'The cron schedule string for when this database should undergo the metadata sync process (and analysis for new fields).';


--
-- Name: COLUMN metabase_database.cache_field_values_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.cache_field_values_schedule IS 'The cron schedule string for when FieldValues for eligible Fields should be updated.';


--
-- Name: COLUMN metabase_database.timezone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.timezone IS 'Timezone identifier for the database, set by the sync process';


--
-- Name: COLUMN metabase_database.is_on_demand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.is_on_demand IS 'Whether we should do On-Demand caching of FieldValues for this DB. This means FieldValues are updated when their Field is used in a Dashboard or Card param.';


--
-- Name: COLUMN metabase_database.options; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.options IS 'Serialized JSON containing various options like QB behavior.';


--
-- Name: COLUMN metabase_database.auto_run_queries; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.auto_run_queries IS 'Whether to automatically run queries when doing simple filtering and summarizing in the Query Builder.';


--
-- Name: metabase_database_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_database_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_database_id_seq OWNER TO postgres;

--
-- Name: metabase_database_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_database_id_seq OWNED BY public.metabase_database.id;


--
-- Name: metabase_field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_field (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    base_type character varying(255) NOT NULL,
    special_type character varying(255),
    active boolean DEFAULT true NOT NULL,
    description text,
    preview_display boolean DEFAULT true NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    table_id integer NOT NULL,
    parent_id integer,
    display_name character varying(254),
    visibility_type character varying(32) DEFAULT 'normal'::character varying NOT NULL,
    fk_target_field_id integer,
    last_analyzed timestamp with time zone,
    points_of_interest text,
    caveats text,
    fingerprint text,
    fingerprint_version integer DEFAULT 0 NOT NULL,
    database_type text NOT NULL,
    has_field_values text,
    settings text
);


ALTER TABLE public.metabase_field OWNER TO postgres;

--
-- Name: COLUMN metabase_field.fingerprint; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.fingerprint IS 'Serialized JSON containing non-identifying information about this Field, such as min, max, and percent JSON. Used for classification.';


--
-- Name: COLUMN metabase_field.fingerprint_version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.fingerprint_version IS 'The version of the fingerprint for this Field. Used so we can keep track of which Fields need to be analyzed again when new things are added to fingerprints.';


--
-- Name: COLUMN metabase_field.database_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.database_type IS 'The actual type of this column in the database. e.g. VARCHAR or TEXT.';


--
-- Name: COLUMN metabase_field.has_field_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.has_field_values IS 'Whether we have FieldValues ("list"), should ad-hoc search ("search"), disable entirely ("none"), or infer dynamically (null)"';


--
-- Name: COLUMN metabase_field.settings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.settings IS 'Serialized JSON FE-specific settings like formatting, etc. Scope of what is stored here may increase in future.';


--
-- Name: metabase_field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_field_id_seq OWNER TO postgres;

--
-- Name: metabase_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_field_id_seq OWNED BY public.metabase_field.id;


--
-- Name: metabase_fieldvalues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_fieldvalues (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "values" text,
    human_readable_values text,
    field_id integer NOT NULL
);


ALTER TABLE public.metabase_fieldvalues OWNER TO postgres;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_fieldvalues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_fieldvalues_id_seq OWNER TO postgres;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_fieldvalues_id_seq OWNED BY public.metabase_fieldvalues.id;


--
-- Name: metabase_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_table (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    rows bigint,
    description text,
    entity_name character varying(254),
    entity_type character varying(254),
    active boolean NOT NULL,
    db_id integer NOT NULL,
    display_name character varying(254),
    visibility_type character varying(254),
    schema character varying(254),
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    fields_hash text
);


ALTER TABLE public.metabase_table OWNER TO postgres;

--
-- Name: COLUMN metabase_table.fields_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_table.fields_hash IS 'Computed hash of all of the fields associated to this table';


--
-- Name: metabase_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_table_id_seq OWNER TO postgres;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_table_id_seq OWNED BY public.metabase_table.id;


--
-- Name: metric; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metric (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    how_is_this_calculated text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metric OWNER TO postgres;

--
-- Name: metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metric_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_id_seq OWNER TO postgres;

--
-- Name: metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metric_id_seq OWNED BY public.metric.id;


--
-- Name: metric_important_field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metric_important_field (
    id integer NOT NULL,
    metric_id integer NOT NULL,
    field_id integer NOT NULL
);


ALTER TABLE public.metric_important_field OWNER TO postgres;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metric_important_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_important_field_id_seq OWNER TO postgres;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metric_important_field_id_seq OWNED BY public.metric_important_field.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    object character varying(254) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_group (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.permissions_group OWNER TO postgres;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_id_seq OWNER TO postgres;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_group_id_seq OWNED BY public.permissions_group.id;


--
-- Name: permissions_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_group_membership (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions_group_membership OWNER TO postgres;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_group_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_membership_id_seq OWNER TO postgres;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_group_membership_id_seq OWNED BY public.permissions_group_membership.id;


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: permissions_revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.permissions_revision OWNER TO postgres;

--
-- Name: TABLE permissions_revision; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.permissions_revision IS 'Used to keep track of changes made to permissions.';


--
-- Name: COLUMN permissions_revision.before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.before IS 'Serialized JSON of the permissions before the changes.';


--
-- Name: COLUMN permissions_revision.after; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.after IS 'Serialized JSON of the permissions after the changes.';


--
-- Name: COLUMN permissions_revision.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN permissions_revision.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN permissions_revision.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_revision_id_seq OWNER TO postgres;

--
-- Name: permissions_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_revision_id_seq OWNED BY public.permissions_revision.id;


--
-- Name: pulse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    skip_if_empty boolean DEFAULT false NOT NULL,
    alert_condition character varying(254),
    alert_first_only boolean,
    alert_above_goal boolean,
    collection_id integer,
    collection_position smallint,
    archived boolean DEFAULT false
);


ALTER TABLE public.pulse OWNER TO postgres;

--
-- Name: COLUMN pulse.skip_if_empty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.skip_if_empty IS 'Skip a scheduled Pulse if none of its questions have any results';


--
-- Name: COLUMN pulse.alert_condition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_condition IS 'Condition (i.e. "rows" or "goal") used as a guard for alerts';


--
-- Name: COLUMN pulse.alert_first_only; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_first_only IS 'True if the alert should be disabled after the first notification';


--
-- Name: COLUMN pulse.alert_above_goal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_above_goal IS 'For a goal condition, alert when above the goal';


--
-- Name: COLUMN pulse.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.collection_id IS 'Options ID of Collection this Pulse belongs to.';


--
-- Name: COLUMN pulse.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: COLUMN pulse.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.archived IS 'Has this pulse been archived?';


--
-- Name: pulse_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_card (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL,
    include_csv boolean DEFAULT false NOT NULL,
    include_xls boolean DEFAULT false NOT NULL
);


ALTER TABLE public.pulse_card OWNER TO postgres;

--
-- Name: COLUMN pulse_card.include_csv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse_card.include_csv IS 'True if a CSV of the data should be included for this pulse card';


--
-- Name: COLUMN pulse_card.include_xls; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse_card.include_xls IS 'True if a XLS of the data should be included for this pulse card';


--
-- Name: pulse_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_card_id_seq OWNER TO postgres;

--
-- Name: pulse_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_card_id_seq OWNED BY public.pulse_card.id;


--
-- Name: pulse_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_channel (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    channel_type character varying(32) NOT NULL,
    details text NOT NULL,
    schedule_type character varying(32) NOT NULL,
    schedule_hour integer,
    schedule_day character varying(64),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    schedule_frame character varying(32),
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pulse_channel OWNER TO postgres;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_id_seq OWNER TO postgres;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_channel_id_seq OWNED BY public.pulse_channel.id;


--
-- Name: pulse_channel_recipient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_channel_recipient (
    id integer NOT NULL,
    pulse_channel_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.pulse_channel_recipient OWNER TO postgres;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_channel_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_recipient_id_seq OWNER TO postgres;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_channel_recipient_id_seq OWNED BY public.pulse_channel_recipient.id;


--
-- Name: pulse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_id_seq OWNER TO postgres;

--
-- Name: pulse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_id_seq OWNED BY public.pulse.id;


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


ALTER TABLE public.qrtz_blob_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_blob_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_blob_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_calendars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE public.qrtz_calendars OWNER TO postgres;

--
-- Name: TABLE qrtz_calendars; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_calendars IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE public.qrtz_cron_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_cron_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_cron_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


ALTER TABLE public.qrtz_fired_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_fired_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_fired_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_job_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE public.qrtz_job_details OWNER TO postgres;

--
-- Name: TABLE qrtz_job_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_job_details IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


ALTER TABLE public.qrtz_locks OWNER TO postgres;

--
-- Name: TABLE qrtz_locks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_locks IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


ALTER TABLE public.qrtz_paused_trigger_grps OWNER TO postgres;

--
-- Name: TABLE qrtz_paused_trigger_grps; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_paused_trigger_grps IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE public.qrtz_scheduler_state OWNER TO postgres;

--
-- Name: TABLE qrtz_scheduler_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_scheduler_state IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE public.qrtz_simple_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_simple_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_simple_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


ALTER TABLE public.qrtz_simprop_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_simprop_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_simprop_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE public.qrtz_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_triggers IS 'Used for Quartz scheduler.';


--
-- Name: query; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query (
    query_hash bytea NOT NULL,
    average_execution_time integer NOT NULL,
    query text
);


ALTER TABLE public.query OWNER TO postgres;

--
-- Name: TABLE query; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query IS 'Information (such as average execution time) for different queries that have been previously ran.';


--
-- Name: COLUMN query.query_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict.)';


--
-- Name: COLUMN query.average_execution_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.average_execution_time IS 'Average execution time for the query, round to nearest number of milliseconds. This is updated as a rolling average.';


--
-- Name: COLUMN query.query; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.query IS 'The actual "query dictionary" for this query.';


--
-- Name: query_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_cache (
    query_hash bytea NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    results bytea NOT NULL
);


ALTER TABLE public.query_cache OWNER TO postgres;

--
-- Name: TABLE query_cache; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query_cache IS 'Cached results of queries are stored here when using the DB-based query cache.';


--
-- Name: COLUMN query_cache.query_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict).';


--
-- Name: COLUMN query_cache.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.updated_at IS 'The timestamp of when these query results were last refreshed.';


--
-- Name: COLUMN query_cache.results; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.results IS 'Cached, compressed results of running the query with the given hash.';


--
-- Name: query_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_execution (
    id integer NOT NULL,
    hash bytea NOT NULL,
    started_at timestamp without time zone NOT NULL,
    running_time integer NOT NULL,
    result_rows integer NOT NULL,
    native boolean NOT NULL,
    context character varying(32),
    error text,
    executor_id integer,
    card_id integer,
    dashboard_id integer,
    pulse_id integer,
    database_id integer
);


ALTER TABLE public.query_execution OWNER TO postgres;

--
-- Name: TABLE query_execution; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query_execution IS 'A log of executed queries, used for calculating historic execution times, auditing, and other purposes.';


--
-- Name: COLUMN query_execution.hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.hash IS 'The hash of the query dictionary. This is a 256-bit SHA3 hash of the query.';


--
-- Name: COLUMN query_execution.started_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.started_at IS 'Timestamp of when this query started running.';


--
-- Name: COLUMN query_execution.running_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.running_time IS 'The time, in milliseconds, this query took to complete.';


--
-- Name: COLUMN query_execution.result_rows; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.result_rows IS 'Number of rows in the query results.';


--
-- Name: COLUMN query_execution.native; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.native IS 'Whether the query was a native query, as opposed to an MBQL one (e.g., created with the GUI).';


--
-- Name: COLUMN query_execution.context; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.context IS 'Short string specifying how this query was executed, e.g. in a Dashboard or Pulse.';


--
-- Name: COLUMN query_execution.error; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.error IS 'Error message returned by failed query, if any.';


--
-- Name: COLUMN query_execution.executor_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.executor_id IS 'The ID of the User who triggered this query execution, if any.';


--
-- Name: COLUMN query_execution.card_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.card_id IS 'The ID of the Card (Question) associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.dashboard_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.dashboard_id IS 'The ID of the Dashboard associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.pulse_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.pulse_id IS 'The ID of the Pulse associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.database_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.database_id IS 'ID of the database this query was ran against.';


--
-- Name: query_execution_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.query_execution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_execution_id_seq OWNER TO postgres;

--
-- Name: query_execution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.query_execution_id_seq OWNED BY public.query_execution.id;


--
-- Name: report_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_card (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    display character varying(254) NOT NULL,
    dataset_query text NOT NULL,
    visualization_settings text NOT NULL,
    creator_id integer NOT NULL,
    database_id integer,
    table_id integer,
    query_type character varying(16),
    archived boolean DEFAULT false NOT NULL,
    collection_id integer,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    cache_ttl integer,
    result_metadata text,
    read_permissions text,
    collection_position smallint
);


ALTER TABLE public.report_card OWNER TO postgres;

--
-- Name: COLUMN report_card.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.collection_id IS 'Optional ID of Collection this Card belongs to.';


--
-- Name: COLUMN report_card.public_uuid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.public_uuid IS 'Unique UUID used to in publically-accessible links to this Card.';


--
-- Name: COLUMN report_card.made_public_by_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.made_public_by_id IS 'The ID of the User who first publically shared this Card.';


--
-- Name: COLUMN report_card.enable_embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.enable_embedding IS 'Is this Card allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_card.embedding_params; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Card.';


--
-- Name: COLUMN report_card.cache_ttl; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.cache_ttl IS 'The maximum time, in seconds, to return cached results for this Card rather than running a new query.';


--
-- Name: COLUMN report_card.result_metadata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.result_metadata IS 'Serialized JSON containing metadata about the result columns from running the query.';


--
-- Name: COLUMN report_card.read_permissions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.read_permissions IS 'Permissions required to view this Card and run its query.';


--
-- Name: COLUMN report_card.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_card_id_seq OWNER TO postgres;

--
-- Name: report_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_card_id_seq OWNED BY public.report_card.id;


--
-- Name: report_cardfavorite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_cardfavorite (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    card_id integer NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.report_cardfavorite OWNER TO postgres;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_cardfavorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_cardfavorite_id_seq OWNER TO postgres;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_cardfavorite_id_seq OWNED BY public.report_cardfavorite.id;


--
-- Name: report_dashboard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_dashboard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    creator_id integer NOT NULL,
    parameters text NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    archived boolean DEFAULT false NOT NULL,
    "position" integer,
    collection_id integer,
    collection_position smallint
);


ALTER TABLE public.report_dashboard OWNER TO postgres;

--
-- Name: COLUMN report_dashboard.public_uuid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.public_uuid IS 'Unique UUID used to in publically-accessible links to this Dashboard.';


--
-- Name: COLUMN report_dashboard.made_public_by_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.made_public_by_id IS 'The ID of the User who first publically shared this Dashboard.';


--
-- Name: COLUMN report_dashboard.enable_embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.enable_embedding IS 'Is this Dashboard allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_dashboard.embedding_params; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Dashboard.';


--
-- Name: COLUMN report_dashboard.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.archived IS 'Is this Dashboard archived (effectively treated as deleted?)';


--
-- Name: COLUMN report_dashboard."position"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard."position" IS 'The position this Dashboard should appear in the Dashboards list, lower-numbered positions appearing before higher numbered ones.';


--
-- Name: COLUMN report_dashboard.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.collection_id IS 'Optional ID of Collection this Dashboard belongs to.';


--
-- Name: COLUMN report_dashboard.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboard_id_seq OWNER TO postgres;

--
-- Name: report_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_dashboard_id_seq OWNED BY public.report_dashboard.id;


--
-- Name: report_dashboardcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_dashboardcard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "sizeX" integer NOT NULL,
    "sizeY" integer NOT NULL,
    "row" integer DEFAULT 0 NOT NULL,
    col integer DEFAULT 0 NOT NULL,
    card_id integer,
    dashboard_id integer NOT NULL,
    parameter_mappings text NOT NULL,
    visualization_settings text NOT NULL
);


ALTER TABLE public.report_dashboardcard OWNER TO postgres;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_dashboardcard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboardcard_id_seq OWNER TO postgres;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_dashboardcard_id_seq OWNED BY public.report_dashboardcard.id;


--
-- Name: revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision (
    id integer NOT NULL,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    object character varying NOT NULL,
    is_reversion boolean DEFAULT false NOT NULL,
    is_creation boolean DEFAULT false NOT NULL,
    message text
);


ALTER TABLE public.revision OWNER TO postgres;

--
-- Name: revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revision_id_seq OWNER TO postgres;

--
-- Name: revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revision_id_seq OWNED BY public.revision.id;


--
-- Name: segment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.segment (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.segment OWNER TO postgres;

--
-- Name: segment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.segment_id_seq OWNER TO postgres;

--
-- Name: segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.segment_id_seq OWNED BY public.segment.id;


--
-- Name: setting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.setting (
    key character varying(254) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.setting OWNER TO postgres;

--
-- Name: task_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_history (
    id integer NOT NULL,
    task character varying(254) NOT NULL,
    db_id integer,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone NOT NULL,
    duration integer NOT NULL,
    task_details text
);


ALTER TABLE public.task_history OWNER TO postgres;

--
-- Name: TABLE task_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.task_history IS 'Timing and metadata info about background/quartz processes';


--
-- Name: COLUMN task_history.task; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.task_history.task IS 'Name of the task';


--
-- Name: COLUMN task_history.task_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.task_history.task_details IS 'JSON string with additional info on the task';


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_history_id_seq OWNER TO postgres;

--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- Name: view_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_log (
    id integer NOT NULL,
    user_id integer,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.view_log OWNER TO postgres;

--
-- Name: view_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.view_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.view_log_id_seq OWNER TO postgres;

--
-- Name: view_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.view_log_id_seq OWNED BY public.view_log.id;


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: card_label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label ALTER COLUMN id SET DEFAULT nextval('public.card_label_id_seq'::regclass);


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: collection_revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_revision ALTER COLUMN id SET DEFAULT nextval('public.collection_revision_id_seq'::regclass);


--
-- Name: computation_job id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job ALTER COLUMN id SET DEFAULT nextval('public.computation_job_id_seq'::regclass);


--
-- Name: computation_job_result id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result ALTER COLUMN id SET DEFAULT nextval('public.computation_job_result_id_seq'::regclass);


--
-- Name: core_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user ALTER COLUMN id SET DEFAULT nextval('public.core_user_id_seq'::regclass);


--
-- Name: dashboard_favorite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite ALTER COLUMN id SET DEFAULT nextval('public.dashboard_favorite_id_seq'::regclass);


--
-- Name: dashboardcard_series id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series ALTER COLUMN id SET DEFAULT nextval('public.dashboardcard_series_id_seq'::regclass);


--
-- Name: dependency id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependency ALTER COLUMN id SET DEFAULT nextval('public.dependency_id_seq'::regclass);


--
-- Name: dimension id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension ALTER COLUMN id SET DEFAULT nextval('public.dimension_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label ALTER COLUMN id SET DEFAULT nextval('public.label_id_seq'::regclass);


--
-- Name: metabase_database id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_database ALTER COLUMN id SET DEFAULT nextval('public.metabase_database_id_seq'::regclass);


--
-- Name: metabase_field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field ALTER COLUMN id SET DEFAULT nextval('public.metabase_field_id_seq'::regclass);


--
-- Name: metabase_fieldvalues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues ALTER COLUMN id SET DEFAULT nextval('public.metabase_fieldvalues_id_seq'::regclass);


--
-- Name: metabase_table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table ALTER COLUMN id SET DEFAULT nextval('public.metabase_table_id_seq'::regclass);


--
-- Name: metric id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric ALTER COLUMN id SET DEFAULT nextval('public.metric_id_seq'::regclass);


--
-- Name: metric_important_field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field ALTER COLUMN id SET DEFAULT nextval('public.metric_important_field_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: permissions_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_id_seq'::regclass);


--
-- Name: permissions_group_membership id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_membership_id_seq'::regclass);


--
-- Name: permissions_revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision ALTER COLUMN id SET DEFAULT nextval('public.permissions_revision_id_seq'::regclass);


--
-- Name: pulse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse ALTER COLUMN id SET DEFAULT nextval('public.pulse_id_seq'::regclass);


--
-- Name: pulse_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card ALTER COLUMN id SET DEFAULT nextval('public.pulse_card_id_seq'::regclass);


--
-- Name: pulse_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_id_seq'::regclass);


--
-- Name: pulse_channel_recipient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_recipient_id_seq'::regclass);


--
-- Name: query_execution id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_execution ALTER COLUMN id SET DEFAULT nextval('public.query_execution_id_seq'::regclass);


--
-- Name: report_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card ALTER COLUMN id SET DEFAULT nextval('public.report_card_id_seq'::regclass);


--
-- Name: report_cardfavorite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite ALTER COLUMN id SET DEFAULT nextval('public.report_cardfavorite_id_seq'::regclass);


--
-- Name: report_dashboard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboard_id_seq'::regclass);


--
-- Name: report_dashboardcard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboardcard_id_seq'::regclass);


--
-- Name: revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision ALTER COLUMN id SET DEFAULT nextval('public.revision_id_seq'::regclass);


--
-- Name: segment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment ALTER COLUMN id SET DEFAULT nextval('public.segment_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- Name: view_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log ALTER COLUMN id SET DEFAULT nextval('public.view_log_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity (id, topic, "timestamp", user_id, model, model_id, database_id, table_id, custom_id, details) FROM stdin;
1	install	2022-09-28 00:52:04.574606+00	\N	install	\N	\N	\N	\N	{}
2	user-joined	2022-09-28 01:19:53.706697+00	1	user	1	\N	\N	\N	{}
\.


--
-- Data for Name: card_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.card_label (id, card_id, label_id) FROM stdin;
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection (id, name, description, color, archived, location, personal_owner_id, slug) FROM stdin;
1	Go Frendi Gunawan's Personal Collection	\N	#31698A	f	/	1	go_frendi_gunawan_s_personal_collection
\.


--
-- Data for Name: collection_revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection_revision (id, before, after, user_id, created_at, remark) FROM stdin;
\.


--
-- Data for Name: computation_job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computation_job (id, creator_id, created_at, updated_at, type, status, context, ended_at) FROM stdin;
\.


--
-- Data for Name: computation_job_result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computation_job_result (id, job_id, created_at, updated_at, permanence, payload) FROM stdin;
\.


--
-- Data for Name: core_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_session (id, user_id, created_at) FROM stdin;
cba8ed17-858c-47ab-a798-4dc3a37dcf2b	1	2022-09-28 01:19:53.697924+00
\.


--
-- Data for Name: core_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_user (id, email, first_name, last_name, password, password_salt, date_joined, last_login, is_superuser, is_active, reset_token, reset_triggered, is_qbnewb, google_auth, ldap_auth, login_attributes, updated_at) FROM stdin;
1	gofrendiasgard@gmail.com	Go Frendi	Gunawan	$2a$10$R3qQ.CENq/ikBXZsJKynFewxvByZszWiipoXQvhg0Vamx4GV9FCvK	5a6021ab-d4d5-4787-976c-ccf71368b65c	2022-09-28 01:19:53.471911+00	2022-09-28 01:19:53.706603+00	t	t	\N	\N	t	f	f	\N	2022-09-28 08:19:53.706603
\.


--
-- Data for Name: dashboard_favorite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_favorite (id, user_id, dashboard_id) FROM stdin;
\.


--
-- Data for Name: dashboardcard_series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboardcard_series (id, dashboardcard_id, card_id, "position") FROM stdin;
\.


--
-- Data for Name: data_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_migrations (id, "timestamp") FROM stdin;
add-users-to-default-permissions-groups	2022-09-28 07:52:04.130006
add-admin-group-root-entry	2022-09-28 07:52:04.148532
add-databases-to-magic-permissions-groups	2022-09-28 07:52:04.153663
migrate-field-types	2022-09-28 07:52:04.215908
fix-invalid-field-types	2022-09-28 07:52:04.221483
copy-site-url-setting-and-remove-trailing-slashes	2022-09-28 07:52:04.225897
drop-old-query-execution-table	2022-09-28 07:52:04.234297
ensure-protocol-specified-in-site-url	2022-09-28 07:52:04.250998
populate-card-database-id	2022-09-28 07:52:04.257299
migrate-humanization-setting	2022-09-28 07:52:04.261208
mark-category-fields-as-list	2022-09-28 07:52:04.274581
add-legacy-sql-directive-to-bigquery-sql-cards	2022-09-28 07:52:04.278959
clear-ldap-user-local-passwords	2022-09-28 07:52:04.285862
add-migrated-collections	2022-09-28 07:52:04.303942
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
4	cammsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.771475	3	EXECUTED	8:a8e7822a91ea122212d376f5c2d4158f	createTable tableName=setting		\N	3.6.3	\N	\N	4326322455
1	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.750686	1	EXECUTED	8:7182ca8e82947c24fa827d31f78b19aa	createTable tableName=core_organization; createTable tableName=core_user; createTable tableName=core_userorgperm; addUniqueConstraint constraintName=idx_unique_user_id_organization_id, tableName=core_userorgperm; createIndex indexName=idx_userorgp...		\N	3.6.3	\N	\N	4326322455
2	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.763132	2	EXECUTED	8:bdcf1238e2ccb4fbe66d7f9e1d9b9529	createTable tableName=core_session		\N	3.6.3	\N	\N	4326322455
5	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.775831	4	EXECUTED	8:4f8653d16f4b102b3dff647277b6b988	addColumn tableName=core_organization		\N	3.6.3	\N	\N	4326322455
6	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.783415	5	EXECUTED	8:2d2f5d1756ecb81da7c09ccfb9b1565a	dropNotNullConstraint columnName=organization_id, tableName=metabase_database; dropForeignKeyConstraint baseTableName=metabase_database, constraintName=fk_database_ref_organization_id; dropNotNullConstraint columnName=organization_id, tableName=re...		\N	3.6.3	\N	\N	4326322455
7	cammsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.788931	6	EXECUTED	8:c57c69fd78d804beb77d261066521f7f	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
8	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:02.793142	7	EXECUTED	8:960ec59bbcb4c9f3fa8362eca9af4075	addColumn tableName=metabase_table; addColumn tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
9	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:02.797714	8	EXECUTED	8:d560283a190e3c60802eb04f5532a49d	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	4326322455
10	cammsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.81005	9	EXECUTED	8:9f03a236be31f54e8e5c894fe5fc7f00	createTable tableName=revision; createIndex indexName=idx_revision_model_model_id, tableName=revision		\N	3.6.3	\N	\N	4326322455
11	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.813128	10	EXECUTED	8:ca6561cab1eedbcf4dcb6d6e22cd46c6	sql		\N	3.6.3	\N	\N	4326322455
12	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.818642	11	EXECUTED	8:bedbea570e5dfc694b4cf5a8f6a4f445	addColumn tableName=report_card		\N	3.6.3	\N	\N	4326322455
13	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.839282	12	EXECUTED	8:c2c65930bad8d3e9bab3bb6ae562fe0c	createTable tableName=activity; createIndex indexName=idx_activity_timestamp, tableName=activity; createIndex indexName=idx_activity_user_id, tableName=activity; createIndex indexName=idx_activity_custom_id, tableName=activity		\N	3.6.3	\N	\N	4326322455
14	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.856557	13	EXECUTED	8:320d2ca8ead3f31309674b2b7f54f395	createTable tableName=view_log; createIndex indexName=idx_view_log_user_id, tableName=view_log; createIndex indexName=idx_view_log_timestamp, tableName=view_log		\N	3.6.3	\N	\N	4326322455
15	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.861324	14	EXECUTED	8:505b91530103673a9be3382cd2db1070	addColumn tableName=revision		\N	3.6.3	\N	\N	4326322455
16	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.864541	15	EXECUTED	8:ecc7f02641a589e6d35f88587ac6e02b	dropNotNullConstraint columnName=last_login, tableName=core_user		\N	3.6.3	\N	\N	4326322455
17	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.869785	16	EXECUTED	8:051c23cd15359364b9895c1569c319e7	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	4326322455
18	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.884864	17	EXECUTED	8:62a0483dde183cfd18dd0a86e9354288	createTable tableName=data_migrations; createIndex indexName=idx_data_migrations_id, tableName=data_migrations		\N	3.6.3	\N	\N	4326322455
19	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.890519	18	EXECUTED	8:269b129dbfc39a6f9e0d3bc61c3c3b70	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	4326322455
20	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.938763	19	EXECUTED	8:0afa34e8b528b83aa19b4142984f8095	createTable tableName=pulse; createIndex indexName=idx_pulse_creator_id, tableName=pulse; createTable tableName=pulse_card; createIndex indexName=idx_pulse_card_pulse_id, tableName=pulse_card; createIndex indexName=idx_pulse_card_card_id, tableNam...		\N	3.6.3	\N	\N	4326322455
21	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.964998	20	EXECUTED	8:fb2cd308b17ab81b502d057ecde4fc1b	createTable tableName=segment; createIndex indexName=idx_segment_creator_id, tableName=segment; createIndex indexName=idx_segment_table_id, tableName=segment		\N	3.6.3	\N	\N	4326322455
22	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.970208	21	EXECUTED	8:80bc8a62a90791a79adedcf1ac3c6f08	addColumn tableName=revision		\N	3.6.3	\N	\N	4326322455
23	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.984599	22	EXECUTED	8:b6f054835db2b2688a1be1de3707f9a9	modifyDataType columnName=rows, tableName=metabase_table		\N	3.6.3	\N	\N	4326322455
24	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.005792	23	EXECUTED	8:60825b125b452747098b577310c142b1	createTable tableName=dependency; createIndex indexName=idx_dependency_model, tableName=dependency; createIndex indexName=idx_dependency_model_id, tableName=dependency; createIndex indexName=idx_dependency_dependent_on_model, tableName=dependency;...		\N	3.6.3	\N	\N	4326322455
25	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.024215	24	EXECUTED	8:61f25563911117df72f5621d78f10089	createTable tableName=metric; createIndex indexName=idx_metric_creator_id, tableName=metric; createIndex indexName=idx_metric_table_id, tableName=metric		\N	3.6.3	\N	\N	4326322455
26	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.028033	25	EXECUTED	8:ddef40b95c55cf4ac0e6a5161911a4cb	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	4326322455
27	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.041667	26	EXECUTED	8:001855139df2d5dac4eb954e5abe6486	createTable tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_dashboardcard_id, tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_card_id, tableName=dashboardcard_series		\N	3.6.3	\N	\N	4326322455
28	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.046647	27	EXECUTED	8:428e4eb05e4e29141735adf9ae141a0b	addColumn tableName=core_user		\N	3.6.3	\N	\N	4326322455
29	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.051656	28	EXECUTED	8:8b02731cc34add3722c926dfd7376ae0	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	4326322455
30	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.057085	29	EXECUTED	8:2c3a50cef177cb90d47a9973cd5934e5	addColumn tableName=metabase_field; addNotNullConstraint columnName=visibility_type, tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
31	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.061489	30	EXECUTED	8:30a33a82bab0bcbb2ccb6738d48e1421	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
57	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.425587	56	EXECUTED	8:aab81d477e2d19a9ab18c58b78c9af88	addColumn tableName=report_card	Added 0.25.0	\N	3.6.3	\N	\N	4326322455
32	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.090521	31	EXECUTED	8:40830260b92cedad8da273afd5eca678	createTable tableName=label; createIndex indexName=idx_label_slug, tableName=label; createTable tableName=card_label; addUniqueConstraint constraintName=unique_card_label_card_id_label_id, tableName=card_label; createIndex indexName=idx_card_label...		\N	3.6.3	\N	\N	4326322455
32	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.119819	32	EXECUTED	8:483c6c6c8e0a8d056f7b9112d0b0125c	createTable tableName=raw_table; createIndex indexName=idx_rawtable_database_id, tableName=raw_table; addUniqueConstraint constraintName=uniq_raw_table_db_schema_name, tableName=raw_table; createTable tableName=raw_column; createIndex indexName=id...		\N	3.6.3	\N	\N	4326322455
34	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:03.124656	33	EXECUTED	8:52b082600b05bbbc46bfe837d1f37a82	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	4326322455
35	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.128891	34	EXECUTED	8:91b72167fca724e6b6a94b64f886cf09	modifyDataType columnName=value, tableName=setting		\N	3.6.3	\N	\N	4326322455
36	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.13762	35	EXECUTED	8:252e08892449dceb16c3d91337bd9573	addColumn tableName=report_dashboard; addNotNullConstraint columnName=parameters, tableName=report_dashboard; addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=parameter_mappings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	4326322455
37	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:03.152035	36	EXECUTED	8:07d959eff81777e5690e2920583cfe5f	addColumn tableName=query_queryexecution; addNotNullConstraint columnName=query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_queryexecution_query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_querye...		\N	3.6.3	\N	\N	4326322455
38	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.188485	37	EXECUTED	8:43604ab55179b50306eb39353e760b46	addColumn tableName=metabase_database; addColumn tableName=metabase_table; addColumn tableName=metabase_field; addColumn tableName=report_dashboard; addColumn tableName=metric; addColumn tableName=segment; addColumn tableName=metabase_database; ad...		\N	3.6.3	\N	\N	4326322455
39	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.193449	38	EXECUTED	8:334adc22af5ded71ff27759b7a556951	addColumn tableName=core_user		\N	3.6.3	\N	\N	4326322455
40	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.247111	39	EXECUTED	8:ee7f50a264d6cf8d891bd01241eebd2c	createTable tableName=permissions_group; createIndex indexName=idx_permissions_group_name, tableName=permissions_group; createTable tableName=permissions_group_membership; addUniqueConstraint constraintName=unique_permissions_group_membership_user...		\N	3.6.3	\N	\N	4326322455
41	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.252811	40	EXECUTED	8:fae0855adf2f702f1133e32fc98d02a5	dropColumn columnName=field_type, tableName=metabase_field; addDefaultValue columnName=active, tableName=metabase_field; addDefaultValue columnName=preview_display, tableName=metabase_field; addDefaultValue columnName=position, tableName=metabase_...		\N	3.6.3	\N	\N	4326322455
42	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.272222	41	EXECUTED	8:e32b3a1624fa289a6ee1f3f0a2dac1f6	dropForeignKeyConstraint baseTableName=query_queryexecution, constraintName=fk_queryexecution_ref_query_id; dropColumn columnName=query_id, tableName=query_queryexecution; dropColumn columnName=is_staff, tableName=core_user; dropColumn columnName=...		\N	3.6.3	\N	\N	4326322455
43	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.287536	42	EXECUTED	8:165e9384e46d6f9c0330784955363f70	createTable tableName=permissions_revision		\N	3.6.3	\N	\N	4326322455
44	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.293268	43	EXECUTED	8:2e356e8a1049286f1c78324828ee7867	dropColumn columnName=public_perms, tableName=report_card; dropColumn columnName=public_perms, tableName=report_dashboard; dropColumn columnName=public_perms, tableName=pulse		\N	3.6.3	\N	\N	4326322455
45	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:03.298124	44	EXECUTED	8:421edd38ee0cb0983162f57193f81b0b	addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=visualization_settings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	4326322455
46	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.303434	45	EXECUTED	8:131df3cdd9a8c67b32c5988a3fb7fe3d	addNotNullConstraint columnName=row, tableName=report_dashboardcard; addNotNullConstraint columnName=col, tableName=report_dashboardcard; addDefaultValue columnName=row, tableName=report_dashboardcard; addDefaultValue columnName=col, tableName=rep...		\N	3.6.3	\N	\N	4326322455
47	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.32538	46	EXECUTED	8:1d2474e49a27db344c250872df58a6ed	createTable tableName=collection; createIndex indexName=idx_collection_slug, tableName=collection; addColumn tableName=report_card; createIndex indexName=idx_card_collection_id, tableName=report_card		\N	3.6.3	\N	\N	4326322455
48	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.335903	47	EXECUTED	8:720ce9d4b9e6f0917aea035e9dc5d95d	createTable tableName=collection_revision		\N	3.6.3	\N	\N	4326322455
49	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.355966	48	EXECUTED	8:56dcab086b21de1df002561efeac8bb6	addColumn tableName=report_card; createIndex indexName=idx_card_public_uuid, tableName=report_card; addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_public_uuid, tableName=report_dashboard; dropNotNullConstraint columnName...		\N	3.6.3	\N	\N	4326322455
50	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.360915	49	EXECUTED	8:388da4c48984aad647709514e4ba9204	addColumn tableName=report_card; addColumn tableName=report_dashboard		\N	3.6.3	\N	\N	4326322455
51	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.377582	50	EXECUTED	8:43c90b5b9f6c14bfd0e41cc0b184617e	createTable tableName=query_execution; createIndex indexName=idx_query_execution_started_at, tableName=query_execution; createIndex indexName=idx_query_execution_query_hash_started_at, tableName=query_execution		\N	3.6.3	\N	\N	4326322455
52	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.390437	51	EXECUTED	8:5af9ea2a96cd6e75a8ac1e6afde7126b	createTable tableName=query_cache; createIndex indexName=idx_query_cache_updated_at, tableName=query_cache; addColumn tableName=report_card		\N	3.6.3	\N	\N	4326322455
53	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.398966	52	EXECUTED	8:78d015c5090c57cd6972eb435601d3d0	createTable tableName=query		\N	3.6.3	\N	\N	4326322455
54	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:03.402572	53	EXECUTED	8:e410005b585f5eeb5f202076ff9468f7	addColumn tableName=pulse		\N	3.6.3	\N	\N	4326322455
55	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.418409	54	EXECUTED	8:87c4becde5fe208ba2c356128df86fba	addColumn tableName=report_dashboard; createTable tableName=dashboard_favorite; addUniqueConstraint constraintName=unique_dashboard_favorite_user_id_dashboard_id, tableName=dashboard_favorite; createIndex indexName=idx_dashboard_favorite_user_id, ...		\N	3.6.3	\N	\N	4326322455
56	wwwiiilll	migrations/000_migrations.yaml	2022-09-28 07:52:03.422279	55	EXECUTED	8:9f46051abaee599e2838733512a32ad0	addColumn tableName=core_user	Added 0.25.0	\N	3.6.3	\N	\N	4326322455
58	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.440825	57	EXECUTED	8:3554219ca39e0fd682d0fba57531e917	createTable tableName=dimension; addUniqueConstraint constraintName=unique_dimension_field_id_name, tableName=dimension; createIndex indexName=idx_dimension_field_id, tableName=dimension	Added 0.25.0	\N	3.6.3	\N	\N	4326322455
59	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.444847	58	EXECUTED	8:5b6ce52371e0e9eee88e6d766225a94b	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
60	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.448836	59	EXECUTED	8:4f997b2cd3309882e900493892381f38	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
61	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.452645	60	EXECUTED	8:7dded6fd5bf74d79b9a0b62511981272	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
62	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.455614	61	EXECUTED	8:cb32e6eaa1a2140703def2730f81fef2	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
63	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.458962	62	EXECUTED	8:226f73b9f6617495892d281b0f8303db	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
64	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.462195	63	EXECUTED	8:4dcc8ffd836b56756f494d5dfce07b50	dropForeignKeyConstraint baseTableName=raw_table, constraintName=fk_rawtable_ref_database	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
66	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.471199	64	EXECUTED	8:e77d66af8e3b83d46c5a0064a75a1aac	sql; sql	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
67	attekei	migrations/000_migrations.yaml	2022-09-28 07:52:03.489813	65	EXECUTED	8:59dfc37744fc362e0e312488fbc9a69b	createTable tableName=computation_job; createTable tableName=computation_job_result	Added 0.27.0	\N	3.6.3	\N	\N	4326322455
68	sbelak	migrations/000_migrations.yaml	2022-09-28 07:52:03.494501	66	EXECUTED	8:ca201aeb20c1719a46c6bcc3fc95c81d	addColumn tableName=computation_job	Added 0.27.0	\N	3.6.3	\N	\N	4326322455
69	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.503417	67	EXECUTED	8:97b7768436b9e8d695bae984020d754c	addColumn tableName=pulse; dropNotNullConstraint columnName=name, tableName=pulse	Added 0.27.0	\N	3.6.3	\N	\N	4326322455
70	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.50797	68	EXECUTED	8:4e4eff7abb983b1127a32ba8107e7fb8	addColumn tableName=metabase_field; addNotNullConstraint columnName=database_type, tableName=metabase_field	Added 0.28.0	\N	3.6.3	\N	\N	4326322455
71	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.510718	69	EXECUTED	8:755e5c3dd8a55793f29b2c95cb79c211	dropNotNullConstraint columnName=card_id, tableName=report_dashboardcard	Added 0.28.0	\N	3.6.3	\N	\N	4326322455
72	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.514379	70	EXECUTED	8:ed16046dfa04c139f48e9068eb4faee4	addColumn tableName=pulse_card	Added 0.28.0	\N	3.6.3	\N	\N	4326322455
73	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.517456	71	EXECUTED	8:3c0f03d18ff78a0bcc9915e1d9c518d6	addColumn tableName=metabase_database	Added 0.29.0	\N	3.6.3	\N	\N	4326322455
74	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.521116	72	EXECUTED	8:16726d6560851325930c25caf3c8ab96	addColumn tableName=metabase_field	Added 0.29.0	\N	3.6.3	\N	\N	4326322455
75	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.524166	73	EXECUTED	8:6072cabfe8188872d8e3da9a675f88c1	addColumn tableName=report_card	Added 0.28.2	\N	3.6.3	\N	\N	4326322455
76	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.526927	74	EXECUTED	8:9b7190c9171ccca72617d508875c3c82	addColumn tableName=metabase_table	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
77	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.529874	75	EXECUTED	8:07f0a6cd8dbbd9b89be0bd7378f7bdc8	addColumn tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
117	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.820232	108	MARK_RAN	8:f2d7f9fb1b6713bc5362fe40bfe3f91f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
79	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.539608	76	EXECUTED	8:3f31cb67f9cdf7754ca95cade22d87a2	addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_collection_id, tableName=report_dashboard; addColumn tableName=pulse; createIndex indexName=idx_pulse_collection_id, tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
80	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.545785	77	EXECUTED	8:199d0ce28955117819ca15bcc29323e5	addColumn tableName=collection; createIndex indexName=idx_collection_location, tableName=collection		\N	3.6.3	\N	\N	4326322455
81	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.550101	78	EXECUTED	8:3a6dc22403660529194d004ca7f7ad39	addColumn tableName=report_dashboard; addColumn tableName=report_card; addColumn tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
82	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.556749	79	EXECUTED	8:ac4b94df8c648f88cfff661284d6392d	addColumn tableName=core_user; sql	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
84	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.563603	80	EXECUTED	8:58afc10c3e283a8050ea471aac447a97	renameColumn newColumnName=archived, oldColumnName=is_active, tableName=metric; addDefaultValue columnName=archived, tableName=metric; renameColumn newColumnName=archived, oldColumnName=is_active, tableName=segment; addDefaultValue columnName=arch...	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
85	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.576988	81	EXECUTED	8:9b4c9878a5018452dd63eb6d7c17f415	addColumn tableName=collection; createIndex indexName=idx_collection_personal_owner_id, tableName=collection; addColumn tableName=collection; sql; addNotNullConstraint columnName=_slug, tableName=collection; dropColumn columnName=slug, tableName=c...	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
86	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.579932	82	EXECUTED	8:50c75bb29f479e0b3fb782d89f7d6717	sql	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
87	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.587476	83	EXECUTED	8:0eccf19a93cb0ba4017aafd1d308c097	dropTable tableName=raw_column; dropTable tableName=raw_table	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
89	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.716334	84	EXECUTED	8:94d5c406e3ec44e2bc85abe96f6fd91c	createTable tableName=QRTZ_JOB_DETAILS; addPrimaryKey constraintName=PK_QRTZ_JOB_DETAILS, tableName=QRTZ_JOB_DETAILS; createTable tableName=QRTZ_TRIGGERS; addPrimaryKey constraintName=PK_QRTZ_TRIGGERS, tableName=QRTZ_TRIGGERS; addForeignKeyConstra...	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
91	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.720581	85	EXECUTED	8:9b8831e1e409f08e874c4ece043d0340	dropColumn columnName=raw_table_id, tableName=metabase_table; dropColumn columnName=raw_column_id, tableName=metabase_field	Added 0.30.0	\N	3.6.3	\N	\N	4326322455
92	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.72366	86	EXECUTED	8:1e5bc2d66778316ea640a561862c23b4	addColumn tableName=query_execution	Added 0.31.0	\N	3.6.3	\N	\N	4326322455
93	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.726535	87	EXECUTED	8:93b0d408a3970e30d7184ed1166b5476	addColumn tableName=query	Added 0.31.0	\N	3.6.3	\N	\N	4326322455
138	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.865239	129	MARK_RAN	8:bfb201761052189e96538f0de3ac76cf	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
94	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.739651	88	EXECUTED	8:a2a1eedf1e8f8756856c9d49c7684bfe	createTable tableName=task_history; createIndex indexName=idx_task_history_end_time, tableName=task_history; createIndex indexName=idx_task_history_db_id, tableName=task_history	Added 0.31.0	\N	3.6.3	\N	\N	4326322455
95	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.746158	89	EXECUTED	8:9824808283004e803003b938399a4cf0	addUniqueConstraint constraintName=idx_databasechangelog_id_author_filename, tableName=DATABASECHANGELOG	Added 0.31.0	\N	3.6.3	\N	\N	4326322455
96	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.749589	90	EXECUTED	8:5cb2f36edcca9c6e14c5e109d6aeb68b	addColumn tableName=metabase_field	Added 0.31.0	\N	3.6.3	\N	\N	4326322455
97	senior	migrations/000_migrations.yaml	2022-09-28 07:52:03.751523	91	MARK_RAN	8:9169e238663c5d036bd83428d2fa8e4b	modifyDataType columnName=results, tableName=query_cache	Added 0.32.0	\N	3.6.3	\N	\N	4326322455
98	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.760693	92	EXECUTED	8:f036d20a4dc86fb60ffb64ea838ed6b9	addUniqueConstraint constraintName=idx_uniq_table_db_id_schema_name, tableName=metabase_table; sql	Added 0.32.0	\N	3.6.3	\N	\N	4326322455
99	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.769625	93	EXECUTED	8:274bb516dd95b76c954b26084eed1dfe	addUniqueConstraint constraintName=idx_uniq_field_table_id_parent_id_name, tableName=metabase_field; sql	Added 0.32.0	\N	3.6.3	\N	\N	4326322455
100	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.773725	94	EXECUTED	8:948014f13b6198b50e3b7a066fae2ae0	sql	Added 0.32.0	\N	3.6.3	\N	\N	4326322455
101	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.78093	95	EXECUTED	8:58eabb08a175fafe8985208545374675	createIndex indexName=idx_field_parent_id, tableName=metabase_field	Added 0.32.0	\N	3.6.3	\N	\N	4326322455
103	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.785295	96	EXECUTED	8:fda3670fd16a40fd9d0f89a003098d54	addColumn tableName=metabase_database	Added 0.32.10	\N	3.6.3	\N	\N	4326322455
106	sb	migrations/000_migrations.yaml	2022-09-28 07:52:03.788402	97	EXECUTED	8:a3dd42bbe25c415ce21e4c180dc1c1d7	modifyDataType columnName=database_type, tableName=metabase_field	Added 0.34.0	\N	3.6.3	\N	\N	4326322455
107	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.79049	98	MARK_RAN	8:605c2b4d212315c83727aa3d914cf57f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
108	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.792257	99	MARK_RAN	8:d11419da9384fd27d7b1670707ac864c	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
109	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.794462	100	MARK_RAN	8:a5f4ea412eb1d5c1bc824046ad11692f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
110	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.796339	101	MARK_RAN	8:82343097044b9652f73f3d3a2ddd04fe	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
111	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.798181	102	MARK_RAN	8:528de1245ba3aa106871d3e5b3eee0ba	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
112	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.799925	103	MARK_RAN	8:010a3931299429d1adfa91941c806ea4	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
113	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.810001	104	MARK_RAN	8:8f8e0836064bdea82487ecf64a129767	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
114	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.812854	105	MARK_RAN	8:7a0bcb25ece6d9a311d6c6be7ed89bb7	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
115	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.815317	106	MARK_RAN	8:55c10c2ff7e967e3ea1fdffc5aeed93a	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
116	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.817697	107	MARK_RAN	8:dbf7c3a1d8b1eb77b7f5888126b13c2e	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
118	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.82333	109	MARK_RAN	8:17f4410e30a0c7e84a36517ebf4dab64	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
119	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.825991	110	MARK_RAN	8:195cf171ac1d5531e455baf44d9d6561	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
120	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.828913	111	MARK_RAN	8:61f53fac337020aec71868656a719bba	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
121	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.830919	112	MARK_RAN	8:1baa145d2ffe1e18d097a63a95476c5f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
122	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.832761	113	MARK_RAN	8:929b3c551a8f631cdce2511612d82d62	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
123	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.83436	114	MARK_RAN	8:35e5baddf78df5829fe6889d216436e5	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
124	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.836194	115	MARK_RAN	8:ce2322ca187dfac51be8f12f6a132818	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
125	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.838188	116	MARK_RAN	8:dd948ac004ceb9d0a300a8e06806945f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
126	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.840599	117	MARK_RAN	8:3d34c0d4e5dbb32b432b83d5322e2aa3	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
127	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.843614	118	MARK_RAN	8:18314b269fe11898a433ca9048400975	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
128	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.846126	119	MARK_RAN	8:44acbe257817286d88b7892e79363b66	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
129	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.848188	120	MARK_RAN	8:f890168c47cc2113a8af77ed3875c4b3	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
130	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.850034	121	MARK_RAN	8:ecdcf1fd66b3477e5b6882c3286b2fd8	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
131	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.852219	122	MARK_RAN	8:453af2935194978c65b19eae445d85c9	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
132	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.854028	123	MARK_RAN	8:d2c37bc80b42a15b65f148bcb1daa86e	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
133	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.855775	124	MARK_RAN	8:5b9b539d146fbdb762577dc98e7f3430	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
134	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.858126	125	MARK_RAN	8:4d0f688a168db3e357a808263b6ad355	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
135	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.859882	126	MARK_RAN	8:2ca54b0828c6aca615fb42064f1ec728	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
136	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.861564	127	MARK_RAN	8:7115eebbcf664509b9fc0c39cb6f29e9	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
137	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.863596	128	MARK_RAN	8:da754ac6e51313a32de6f6389b29e1ca	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
139	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.867039	130	MARK_RAN	8:fdad4ec86aefb0cdf850b1929b618508	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
140	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.869618	131	MARK_RAN	8:a0cfe6468160bba8c9d602da736c41fb	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
141	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.871753	132	MARK_RAN	8:b6b7faa02cba069e1ed13e365f59cb6b	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
142	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.87365	133	MARK_RAN	8:0c291eb50cc0f1fef3d55cfe6b62bedb	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
143	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.875489	134	MARK_RAN	8:3d9a5cb41f77a33e834d0562fdddeab6	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
144	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.877295	135	MARK_RAN	8:1d5b7f79f97906105e90d330a17c4062	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
145	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.878782	136	MARK_RAN	8:b162dd48ef850ab4300e2d714eac504e	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
146	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.880293	137	MARK_RAN	8:8c0c1861582d15fe7859358f5d553c91	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
147	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.88195	138	MARK_RAN	8:5ccf590332ea0744414e40a990a43275	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
148	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.883705	139	MARK_RAN	8:12b42e87d40cd7b6399c1fb0c6704fa7	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
149	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.88539	140	MARK_RAN	8:dd45bfc4af5e05701a064a5f2a046d7f	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
150	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.887024	141	MARK_RAN	8:48beda94aeaa494f798c38a66b90fb2a	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
151	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.888601	142	MARK_RAN	8:bb752a7d09d437c7ac294d5ab2600079	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
152	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.897792	143	MARK_RAN	8:4bcbc472f2d6ae3a5e7eca425940e52b	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
153	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.902079	144	MARK_RAN	8:adce2cca96fe0531b00f9bed6bed8352	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
154	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.904859	145	MARK_RAN	8:7a1df4f7a679f47459ea1a1c0991cfba	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
155	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.907554	146	MARK_RAN	8:3c78b79c784e3a3ce09a77db1b1d0374	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
156	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.909722	147	MARK_RAN	8:51859ee6cca4aca9d141a3350eb5d6b1	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
157	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.912198	148	MARK_RAN	8:0197c46bf8536a75dbf7e9aee731f3b2	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
158	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.914909	149	MARK_RAN	8:2ebdd5a179ce2487b2e23b6be74a407c	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
159	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.917478	150	MARK_RAN	8:c62719dad239c51f045315273b56e2a9	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
160	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.91969	151	MARK_RAN	8:1441c71af662abb809cba3b3b360ce81	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: dependency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dependency (id, model, model_id, dependent_on_model, dependent_on_id, created_at) FROM stdin;
\.


--
-- Data for Name: dimension; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dimension (id, field_id, name, type, human_readable_field_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.label (id, name, slug, icon) FROM stdin;
\.


--
-- Data for Name: metabase_database; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_database (id, created_at, updated_at, name, description, details, engine, is_sample, is_full_sync, points_of_interest, caveats, metadata_sync_schedule, cache_field_values_schedule, timezone, is_on_demand, options, auto_run_queries) FROM stdin;
1	2022-09-28 00:52:04.574583+00	2022-09-28 00:52:04.983015+00	Sample Dataset	\N	{"db":"zip:/app/metabase.jar!/sample-dataset.db;USER=GUEST;PASSWORD=guest"}	h2	t	t	\N	\N	0 50 * * * ? *	0 50 0 * * ? *	Asia/Jakarta	f	\N	t
2	2022-09-28 01:19:53.650399+00	2022-09-28 01:19:53.834596+00	Postgresql	\N	{"host":"host.docker.internal","port":5432,"dbname":"sample","user":"postgres","password":"Alch3mist","ssl":false,"tunnel-port":22}	postgres	f	t	\N	\N	0 50 * * * ? *	0 50 0 * * ? *	Asia/Jakarta	f	\N	t
\.


--
-- Data for Name: metabase_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_field (id, created_at, updated_at, name, base_type, special_type, active, description, preview_display, "position", table_id, parent_id, display_name, visibility_type, fk_target_field_id, last_analyzed, points_of_interest, caveats, fingerprint, fingerprint_version, database_type, has_field_values, settings) FROM stdin;
4	2022-09-28 00:52:05.147349+00	2022-09-28 00:52:05.147349+00	ID	type/BigInteger	type/PK	t	This is a unique ID for the product. It is also called the “Invoice number” or “Confirmation number” in customer facing emails and screens.	t	0	2	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
34	2022-09-28 00:52:05.404554+00	2022-09-28 00:52:09.863039+00	REVIEWER	type/Text	\N	t	The user who left the review	t	0	4	\N	Reviewer	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1076,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":9.972122302158274}}}	4	VARCHAR	\N	\N
13	2022-09-28 00:52:05.26769+00	2022-09-28 00:52:05.26769+00	ID	type/BigInteger	type/PK	t	A unique identifier given to each user.	t	0	3	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
26	2022-09-28 00:52:05.369474+00	2022-09-28 00:52:05.369474+00	ID	type/BigInteger	type/PK	t	The numerical product number. Only used internally. All external communication should use the title or EAN.	t	0	1	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
32	2022-09-28 00:52:05.4015+00	2022-09-28 00:52:05.4015+00	ID	type/BigInteger	type/PK	t	A unique internal identifier for the review. Should not be used externally.	t	0	4	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
39	2022-09-28 01:19:54.070689+00	2022-09-28 01:19:55.395883+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	13	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
10	2022-09-28 00:52:05.2561+00	2022-09-28 00:52:09.917863+00	LATITUDE	type/Float	type/Latitude	t	This is the latitude of the user on sign-up. It might be updated in the future to the last seen location.	t	0	3	\N	Latitude	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":25.775827,"max":70.6355001,"avg":39.87934670484002,"sd":6.390832341883712,"q1":35.302705923023126,"q3":43.773802584662}}}	4	DOUBLE	\N	\N
16	2022-09-28 00:52:05.297061+00	2022-09-28 00:52:09.937643+00	SOURCE	type/Text	type/Source	t	The channel through which we acquired this user. Valid values include: Affiliate, Facebook, Google, Organic and Twitter	t	0	3	\N	Source	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":7.4084}}}	4	VARCHAR	auto-list	\N
5	2022-09-28 00:52:05.148977+00	2022-09-28 00:52:07.689784+00	SUBTOTAL	type/Float	\N	t	The raw, pre-tax cost of the order. Note that this might be different in the future from the product price due to promotions, credits, etc.	t	0	2	\N	Subtotal	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":340,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"max":148.22900526552291,"avg":77.01295465356547,"sd":32.53705013056317,"q1":49.74894519060184,"q3":105.42965746993103}}}	4	DOUBLE	\N	\N
1	2022-09-28 00:52:05.141388+00	2022-09-28 00:52:07.696713+00	USER_ID	type/Integer	type/FK	t	The id of the user who made this order. Note that in some cases where an order was created on behalf of a customer who phoned the order in, this might be the employee who handled the request.	t	0	2	\N	User ID	normal	13	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":929,"nil%":0.0}}	4	INTEGER	\N	\N
21	2022-09-28 00:52:05.324012+00	2022-09-28 00:52:09.432295+00	PASSWORD	type/Text	\N	t	This is the salted password of the user. It should not be visible	t	0	3	\N	Password	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	VARCHAR	\N	\N
19	2022-09-28 00:52:05.319118+00	2022-09-28 00:52:09.447439+00	ZIP	type/Text	type/ZipCode	t	The postal code of the account’s billing address	t	0	3	\N	Zip	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2234,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":5.0}}}	4	CHAR	\N	\N
25	2022-09-28 00:52:05.368084+00	2022-09-28 00:52:09.53927+00	PRICE	type/Float	\N	t	The list price of the product. Note that this is not always the price the product sold for due to discounts, promotions, etc.	t	0	1	\N	Price	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":170,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"max":98.81933684368194,"avg":55.74639966792074,"sd":21.711481557852057,"q1":37.25154462926434,"q3":75.45898071609447}}}	4	DOUBLE	\N	\N
33	2022-09-28 00:52:05.403064+00	2022-09-28 00:52:09.851841+00	BODY	type/Text	type/Description	t	The review the user left. Limited to 2000 characters.	t	0	4	\N	Body	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":180.37769784172662}}}	4	CLOB	\N	\N
84	2022-09-28 01:19:54.506572+00	2022-09-28 01:19:55.808791+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	7	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
18	2022-09-28 00:52:05.310033+00	2022-09-28 00:52:09.909663+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the user record was created. Also referred to as the user’s "join date"	t	0	3	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-19T21:35:18.752","latest":"2019-04-19T14:06:27.3"}}}	4	TIMESTAMP	\N	\N
8	2022-09-28 00:52:05.15371+00	2022-09-28 00:52:07.692779+00	TAX	type/Float	\N	t	This is the amount of local and federal taxes that are collected on the purchase. Note that other governmental fees on some products are not included here, but instead are accounted for in the subtotal.	t	0	2	\N	Tax	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":797,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":11.12,"avg":3.8722100000000004,"sd":2.3206651358900316,"q1":2.273340386603857,"q3":5.337275338216307}}}	4	DOUBLE	\N	\N
9	2022-09-28 00:52:05.155145+00	2022-09-28 00:52:07.69485+00	TOTAL	type/Float	\N	t	The total billed amount.	t	0	2	\N	Total	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":10000,"nil%":0.0},"type":{"type/Number":{"min":12.061602936923117,"max":238.32732001721533,"avg":82.96014815230805,"sd":38.35967664847571,"q1":52.006147617878135,"q3":109.55803018499738}}}	4	DOUBLE	\N	\N
14	2022-09-28 00:52:05.271187+00	2022-09-28 00:52:09.416005+00	ADDRESS	type/Text	\N	t	The street address of the account’s billing address	t	0	3	\N	Address	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2490,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":20.85}}}	4	VARCHAR	\N	\N
11	2022-09-28 00:52:05.261253+00	2022-09-28 00:52:09.418666+00	BIRTH_DATE	type/Date	\N	t	The date of birth of the user	t	0	3	\N	Birth Date	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2308,"nil%":0.0},"type":{"type/DateTime":{"earliest":"1958-04-26","latest":"2000-04-03"}}}	4	DATE	\N	\N
12	2022-09-28 00:52:05.263966+00	2022-09-28 00:52:09.932128+00	NAME	type/Text	type/Name	t	The name of the user who owns an account	t	0	3	\N	Name	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2499,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":13.532}}}	4	VARCHAR	\N	\N
3	2022-09-28 00:52:05.145843+00	2022-09-28 00:52:07.684949+00	PRODUCT_ID	type/Integer	type/FK	t	The product ID. This is an internal identifier for the product, NOT the SKU.	t	0	2	\N	Product ID	normal	26	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0}}	4	INTEGER	\N	\N
6	2022-09-28 00:52:05.15045+00	2022-09-28 00:52:09.894247+00	QUANTITY	type/Integer	type/Quantity	t	Number of products bought.	t	0	2	\N	Quantity	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":62,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":100.0,"avg":3.7015,"sd":4.214258386403798,"q1":1.755882607764982,"q3":4.882654507928044}}}	4	INTEGER	auto-list	\N
20	2022-09-28 00:52:05.321934+00	2022-09-28 00:52:09.943441+00	STATE	type/Text	type/State	t	The state or province of the account’s billing address	t	0	3	\N	State	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":49,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":2.0}}}	4	CHAR	auto-list	\N
28	2022-09-28 00:52:05.375677+00	2022-09-28 00:52:09.954077+00	CATEGORY	type/Text	type/Category	t	The type of product, valid values include: Doohicky, Gadget, Gizmo and Widget	t	0	1	\N	Category	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":6.375}}}	4	VARCHAR	auto-list	\N
24	2022-09-28 00:52:05.366399+00	2022-09-28 00:52:09.961841+00	RATING	type/Float	type/Score	t	The average rating users have given the product. This ranges from 1 - 5	t	0	1	\N	Rating	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":23,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":5.0,"avg":3.4715,"sd":1.3605488657451452,"q1":3.5120465053408525,"q3":4.216124969497314}}}	4	DOUBLE	\N	\N
23	2022-09-28 00:52:05.364374+00	2022-09-28 00:52:09.537315+00	EAN	type/Text	\N	t	The international article number. A 13 digit number uniquely identifying the product.	t	0	1	\N	Ean	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":13.0}}}	4	CHAR	\N	\N
30	2022-09-28 00:52:05.379057+00	2022-09-28 00:52:09.968702+00	VENDOR	type/Text	type/Company	t	The source of the product.	t	0	1	\N	Vendor	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":20.6}}}	4	VARCHAR	\N	\N
35	2022-09-28 00:52:05.406008+00	2022-09-28 00:52:09.975221+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The day and time a review was written by a user.	t	0	4	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-06-03T00:37:05.818","latest":"2020-04-19T14:15:25.677"}}}	4	TIMESTAMP	\N	\N
31	2022-09-28 00:52:05.399625+00	2022-09-28 00:52:09.85763+00	PRODUCT_ID	type/Integer	type/FK	t	The product the review was for	t	0	4	\N	Product ID	normal	26	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":176,"nil%":0.0}}	4	INTEGER	\N	\N
2	2022-09-28 00:52:05.144093+00	2022-09-28 00:52:09.887833+00	DISCOUNT	type/Float	type/Discount	t	Discount amount.	t	0	2	\N	Discount	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":701,"nil%":0.898},"type":{"type/Number":{"min":0.17088996672584322,"max":61.69684269960571,"avg":5.161255547580326,"sd":3.053663125001991,"q1":2.9786226681458743,"q3":7.338187788658235}}}	4	DOUBLE	\N	\N
7	2022-09-28 00:52:05.151886+00	2022-09-28 00:52:09.884039+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date and time an order was submitted.	t	0	2	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":9998,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-30T18:56:13.352","latest":"2020-04-19T14:07:15.657"}}}	4	TIMESTAMP	\N	\N
22	2022-09-28 00:52:05.325737+00	2022-09-28 00:52:09.905875+00	CITY	type/Text	type/City	t	The city of the account’s billing address	t	0	3	\N	City	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1966,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":8.284}}}	4	VARCHAR	\N	\N
17	2022-09-28 00:52:05.307291+00	2022-09-28 00:52:09.914239+00	EMAIL	type/Text	type/Email	t	The contact email for the account.	t	0	3	\N	Email	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":1.0,"average-length":24.1824}}}	4	VARCHAR	\N	\N
15	2022-09-28 00:52:05.274838+00	2022-09-28 00:52:09.928189+00	LONGITUDE	type/Float	type/Longitude	t	This is the longitude of the user on sign-up. It might be updated in the future to the last seen location.	t	0	3	\N	Longitude	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":-166.5425726,"max":-67.96735199999999,"avg":-95.18741780363999,"sd":15.399698968175663,"q1":-101.58350792373135,"q3":-84.65289348288829}}}	4	DOUBLE	\N	\N
29	2022-09-28 00:52:05.377297+00	2022-09-28 00:52:09.957919+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the product was added to our catalog.	t	0	1	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-26T19:29:55.147","latest":"2019-04-15T13:34:19.931"}}}	4	TIMESTAMP	\N	\N
27	2022-09-28 00:52:05.373835+00	2022-09-28 00:52:09.965098+00	TITLE	type/Text	type/Title	t	The name of the product as it should be displayed to customers.	t	0	1	\N	Title	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":199,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":21.495}}}	4	VARCHAR	\N	\N
36	2022-09-28 00:52:05.407502+00	2022-09-28 00:52:09.979102+00	RATING	type/Integer	type/Score	t	The rating (on a scale of 1-5) the user left.	t	0	4	\N	Rating	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Number":{"min":1.0,"max":5.0,"avg":3.987410071942446,"sd":1.0443899855660577,"q1":3.54744353181696,"q3":4.764807071650455}}}	4	SMALLINT	auto-list	\N
38	2022-09-28 01:19:54.068081+00	2022-09-28 01:19:54.068081+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	13	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
41	2022-09-28 01:19:54.130849+00	2022-09-28 01:19:54.130849+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	12	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
43	2022-09-28 01:19:54.164816+00	2022-09-28 01:19:54.164816+00	_airbyte_data	type/Text	\N	t	\N	t	0	8	\N	Air Byte Data	normal	\N	\N	\N	\N	\N	0	jsonb	\N	\N
44	2022-09-28 01:19:54.166877+00	2022-09-28 01:19:54.166877+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	8	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
45	2022-09-28 01:19:54.168821+00	2022-09-28 01:19:54.168821+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	8	\N	Air Byte Emitted At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
47	2022-09-28 01:19:54.210181+00	2022-09-28 01:19:54.210181+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	11	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
50	2022-09-28 01:19:54.244782+00	2022-09-28 01:19:54.244782+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	10	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
69	2022-09-28 01:19:54.404507+00	2022-09-28 01:19:54.404507+00	json_permissions	type/Text	\N	t	\N	t	0	9	\N	Json Permissions	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
70	2022-09-28 01:19:54.406565+00	2022-09-28 01:19:54.406565+00	name	type/Text	\N	t	\N	t	0	9	\N	Name	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
71	2022-09-28 01:19:54.408634+00	2022-09-28 01:19:54.408634+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	9	\N	Air Byte Emitted At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
72	2022-09-28 01:19:54.410929+00	2022-09-28 01:19:54.410929+00	created_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	9	\N	Created At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
73	2022-09-28 01:19:54.41258+00	2022-09-28 01:19:54.41258+00	_airbyte_ab_id	type/Text	\N	t	\N	t	0	9	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
74	2022-09-28 01:19:54.414296+00	2022-09-28 01:19:54.414296+00	updated_by	type/Text	\N	t	\N	t	0	9	\N	Updated By	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
75	2022-09-28 01:19:54.416564+00	2022-09-28 01:19:54.416564+00	updated_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	9	\N	Updated At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
76	2022-09-28 01:19:54.418239+00	2022-09-28 01:19:54.418239+00	_airbyte_roles_hashid	type/Text	\N	t	\N	t	0	9	\N	Air Byte Roles Hash ID	normal	\N	\N	\N	\N	\N	0	text	\N	\N
77	2022-09-28 01:19:54.419795+00	2022-09-28 01:19:54.419795+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	9	\N	Air Byte Normalized At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
79	2022-09-28 01:19:54.423821+00	2022-09-28 01:19:54.423821+00	created_by	type/Text	\N	t	\N	t	0	9	\N	Created By	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
46	2022-09-28 01:19:54.208136+00	2022-09-28 01:19:55.922552+00	_airbyte_data	type/Text	type/Category	t	\N	t	0	11	\N	Air Byte Data	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":350.0}}}	4	jsonb	auto-list	\N
67	2022-09-28 01:19:54.346902+00	2022-09-28 01:19:55.986018+00	id	type/Text	type/PK	t	\N	t	0	6	\N	ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	\N	4	varchar	\N	\N
42	2022-09-28 01:19:54.132644+00	2022-09-28 01:19:55.439917+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	12	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
48	2022-09-28 01:19:54.211788+00	2022-09-28 01:19:55.502698+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	11	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
51	2022-09-28 01:19:54.246374+00	2022-09-28 01:19:55.538042+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	10	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
58	2022-09-28 01:19:54.328328+00	2022-09-28 01:19:55.651416+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	6	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
66	2022-09-28 01:19:54.344803+00	2022-09-28 01:19:55.674238+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	6	\N	Air Byte Normalized At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:47.566994Z","latest":"2022-09-28T01:18:47.566994Z"}}}	4	timestamptz	\N	\N
92	2022-09-28 01:19:54.522518+00	2022-09-28 01:19:55.784366+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	7	\N	Air Byte Normalized At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:47.571689Z","latest":"2022-09-28T01:18:47.571689Z"}}}	4	timestamptz	\N	\N
94	2022-09-28 01:19:54.526593+00	2022-09-28 01:19:56.012971+00	_airbyte_users_hashid	type/Text	type/Category	t	\N	t	0	7	\N	Air Byte Users Hash ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":32.0}}}	4	text	auto-list	\N
95	2022-09-28 01:19:54.528287+00	2022-09-28 01:19:56.018401+00	json_role_ids	type/Text	type/Category	t	\N	t	0	7	\N	Json Role Ids	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":2.0}}}	4	varchar	auto-list	\N
97	2022-09-28 01:19:54.592163+00	2022-09-28 01:19:56.077209+00	content_id	type/Text	type/Category	t	\N	t	0	14	\N	Content ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
99	2022-09-28 01:19:54.595912+00	2022-09-28 01:19:56.080127+00	user_id	type/Text	type/Category	t	\N	t	0	14	\N	User ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":5.0}}}	4	varchar	auto-list	\N
101	2022-09-28 01:19:54.599685+00	2022-09-28 01:19:56.082731+00	created_at	type/DateTimeWithLocalTZ	type/CreationTimestamp	t	\N	t	0	14	\N	Created At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-27T22:53:30Z","latest":"2022-09-28T01:17:16Z"}}}	4	timestamptz	\N	\N
107	2022-09-28 01:19:54.608199+00	2022-09-28 01:19:56.086629+00	id	type/Text	type/PK	t	\N	t	0	14	\N	ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	\N	4	varchar	\N	\N
104	2022-09-28 01:19:54.604193+00	2022-09-28 01:19:55.880942+00	updated_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	14	\N	Updated At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-27T22:53:30Z","latest":"2022-09-28T01:17:16Z"}}}	4	timestamptz	\N	\N
106	2022-09-28 01:19:54.606955+00	2022-09-28 01:19:55.885188+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	14	\N	Air Byte Normalized At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:47.57164Z","latest":"2022-09-28T01:18:47.57164Z"}}}	4	timestamptz	\N	\N
37	2022-09-28 01:19:54.064186+00	2022-09-28 01:19:55.908969+00	_airbyte_data	type/Text	type/Category	t	\N	t	0	13	\N	Air Byte Data	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":31.0}}}	4	jsonb	auto-list	\N
53	2022-09-28 01:19:54.281213+00	2022-09-28 01:19:55.93896+00	version_num	type/Text	type/Category	t	\N	t	0	5	\N	Version Num	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":12.0}}}	4	varchar	auto-list	\N
57	2022-09-28 01:19:54.326225+00	2022-09-28 01:19:55.955538+00	url	type/Text	type/URL	t	\N	t	0	6	\N	URL	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":1.0,"percent-email":0.0,"average-length":65.33333333333333}}}	4	varchar	auto-list	\N
61	2022-09-28 01:19:54.335384+00	2022-09-28 01:19:55.960088+00	title	type/Text	type/Title	t	\N	t	0	6	\N	Title	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":14.0}}}	4	varchar	auto-list	\N
62	2022-09-28 01:19:54.337634+00	2022-09-28 01:19:55.964375+00	created_at	type/DateTimeWithLocalTZ	type/CreationTimestamp	t	\N	t	0	6	\N	Created At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-25T12:42:04Z","latest":"2022-09-25T12:47:45Z"}}}	4	timestamptz	\N	\N
64	2022-09-28 01:19:54.341007+00	2022-09-28 01:19:55.968134+00	updated_by	type/Text	type/Category	t	\N	t	0	6	\N	Updated By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.6666666666666667},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":12.0}}}	4	varchar	auto-list	\N
93	2022-09-28 01:19:54.524704+00	2022-09-28 01:19:56.007901+00	id	type/Text	type/PK	t	\N	t	0	7	\N	ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	\N	4	varchar	\N	\N
100	2022-09-28 01:19:54.598023+00	2022-09-28 01:19:55.873228+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	14	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
40	2022-09-28 01:19:54.128657+00	2022-09-28 01:19:55.914993+00	_airbyte_data	type/Text	type/Category	t	\N	t	0	12	\N	Air Byte Data	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":322.3333333333333}}}	4	jsonb	auto-list	\N
55	2022-09-28 01:19:54.284494+00	2022-09-28 01:19:55.943013+00	_airbyte_alembic_version_hashid	type/Text	type/Category	t	\N	t	0	5	\N	Air Byte Alembic Version Hash ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":32.0}}}	4	text	auto-list	\N
96	2022-09-28 01:19:54.530099+00	2022-09-28 01:19:56.022393+00	created_by	type/Text	type/Author	t	\N	t	0	7	\N	Created By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":1.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":0.0}}}	4	varchar	auto-list	\N
80	2022-09-28 01:19:54.482774+00	2022-09-28 01:19:56.032487+00	json_permissions	type/Text	type/Category	t	\N	t	0	7	\N	Json Permissions	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":8.0}}}	4	varchar	auto-list	\N
82	2022-09-28 01:19:54.488673+00	2022-09-28 01:19:56.035932+00	full_name	type/Text	type/Name	t	\N	t	0	7	\N	Full Name	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":4.0}}}	4	varchar	auto-list	\N
86	2022-09-28 01:19:54.510244+00	2022-09-28 01:19:56.040358+00	phone_number	type/Text	type/Category	t	\N	t	0	7	\N	Phone Number	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":12.0}}}	4	varchar	auto-list	\N
88	2022-09-28 01:19:54.514813+00	2022-09-28 01:19:56.044664+00	_airbyte_ab_id	type/Text	type/Category	t	\N	t	0	7	\N	Air Byte Ab ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
90	2022-09-28 01:19:54.518947+00	2022-09-28 01:19:56.050889+00	updated_by	type/Text	\N	t	\N	t	0	7	\N	Updated By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":1.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":0.0}}}	4	varchar	auto-list	\N
87	2022-09-28 01:19:54.512067+00	2022-09-28 01:19:56.067943+00	created_at	type/DateTimeWithLocalTZ	type/CreationTimestamp	t	\N	t	0	7	\N	Created At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-25T12:35:50Z","latest":"2022-09-25T12:35:50Z"}}}	4	timestamptz	\N	\N
102	2022-09-28 01:19:54.601168+00	2022-09-28 01:19:56.092494+00	_airbyte_ab_id	type/Text	type/Category	t	\N	t	0	14	\N	Air Byte Ab ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
105	2022-09-28 01:19:54.605729+00	2022-09-28 01:19:56.098147+00	session_id	type/Text	type/Category	t	\N	t	0	14	\N	Session ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
108	2022-09-28 01:19:54.609711+00	2022-09-28 01:19:56.101001+00	created_by	type/Text	type/Author	t	\N	t	0	14	\N	Created By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":5.0}}}	4	varchar	auto-list	\N
49	2022-09-28 01:19:54.242851+00	2022-09-28 01:19:55.932088+00	_airbyte_data	type/Text	type/Category	t	\N	t	0	10	\N	Air Byte Data	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/Text":{"percent-json":1.0,"percent-url":0.0,"percent-email":0.0,"average-length":308.0}}}	4	jsonb	auto-list	\N
54	2022-09-28 01:19:54.282945+00	2022-09-28 01:19:55.947177+00	_airbyte_ab_id	type/Text	type/Category	t	\N	t	0	5	\N	Air Byte Ab ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
52	2022-09-28 01:19:54.279178+00	2022-09-28 01:19:55.577981+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	5	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
59	2022-09-28 01:19:54.330436+00	2022-09-28 01:19:55.973698+00	_airbyte_contents_hashid	type/Text	type/Category	t	\N	t	0	6	\N	Air Byte Contents Hash ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":32.0}}}	4	text	auto-list	\N
56	2022-09-28 01:19:54.285913+00	2022-09-28 01:19:55.594782+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	5	\N	Air Byte Normalized At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:47.560424Z","latest":"2022-09-28T01:18:47.560424Z"}}}	4	timestamptz	\N	\N
60	2022-09-28 01:19:54.332628+00	2022-09-28 01:19:55.977802+00	description	type/Text	type/Description	t	\N	t	0	6	\N	Description	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":23.333333333333332}}}	4	varchar	auto-list	\N
63	2022-09-28 01:19:54.339349+00	2022-09-28 01:19:55.980948+00	_airbyte_ab_id	type/Text	type/Category	t	\N	t	0	6	\N	Air Byte Ab ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
65	2022-09-28 01:19:54.342651+00	2022-09-28 01:19:55.670932+00	updated_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	6	\N	Updated At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.6666666666666667},"type":{"type/DateTime":{"earliest":"2022-09-25T12:44:25Z","latest":"2022-09-25T12:44:25Z"}}}	4	timestamptz	\N	\N
68	2022-09-28 01:19:54.348774+00	2022-09-28 01:19:55.98914+00	created_by	type/Text	type/Author	t	\N	t	0	6	\N	Created By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
78	2022-09-28 01:19:54.421794+00	2022-09-28 01:19:55.995568+00	id	type/Text	type/PK	t	\N	t	0	9	\N	ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	\N	4	varchar	\N	\N
81	2022-09-28 01:19:54.485865+00	2022-09-28 01:19:56.054513+00	hashed_password	type/Text	type/Category	t	\N	t	0	7	\N	Hashed Password	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":60.0}}}	4	varchar	auto-list	\N
83	2022-09-28 01:19:54.503937+00	2022-09-28 01:19:56.061767+00	active	type/Boolean	type/Category	t	\N	t	0	7	\N	Active	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0}}	4	bool	auto-list	\N
85	2022-09-28 01:19:54.508676+00	2022-09-28 01:19:56.065149+00	email	type/Text	type/Category	t	\N	t	0	7	\N	Email	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":1.0,"average-length":18.0}}}	4	varchar	auto-list	\N
89	2022-09-28 01:19:54.516924+00	2022-09-28 01:19:56.071064+00	username	type/Text	type/Category	t	\N	t	0	7	\N	Username	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":4.0}}}	4	varchar	auto-list	\N
91	2022-09-28 01:19:54.520815+00	2022-09-28 01:19:55.82248+00	updated_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	7	\N	Updated At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":1.0},"type":{"type/DateTime":{"earliest":null,"latest":null}}}	4	timestamptz	\N	\N
98	2022-09-28 01:19:54.594305+00	2022-09-28 01:19:56.089296+00	_airbyte_views_hashid	type/Text	type/Category	t	\N	t	0	14	\N	Air Byte Views Hash ID	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":32.0}}}	4	text	auto-list	\N
103	2022-09-28 01:19:54.60267+00	2022-09-28 01:19:56.095237+00	updated_by	type/Text	type/Category	t	\N	t	0	14	\N	Updated By	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":5.0}}}	4	varchar	auto-list	\N
\.


--
-- Data for Name: metabase_fieldvalues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_fieldvalues (id, created_at, updated_at, "values", human_readable_values, field_id) FROM stdin;
1	2022-09-28 00:52:10.509346+00	2022-09-28 00:52:10.509346+00	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,63,65,67,68,69,70,71,72,73,75,78,82,83,88,100]	\N	6
2	2022-09-28 00:52:10.554064+00	2022-09-28 00:52:10.554064+00	["Affiliate","Facebook","Google","Organic","Twitter"]	\N	16
3	2022-09-28 00:52:10.575734+00	2022-09-28 00:52:10.575734+00	["AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"]	\N	20
4	2022-09-28 00:52:10.599662+00	2022-09-28 00:52:10.599662+00	["Doohickey","Gadget","Gizmo","Widget"]	\N	28
5	2022-09-28 00:52:10.641665+00	2022-09-28 00:52:10.641665+00	[1,2,3,4,5]	\N	36
6	2022-09-28 01:19:56.222052+00	2022-09-28 01:19:56.222052+00	["{\\"version_num\\": \\"eb368989c04b\\"}"]	\N	37
7	2022-09-28 01:19:56.266025+00	2022-09-28 01:19:56.266025+00	["{\\"id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"url\\": \\"https://c.tenor.com/JFb7OjmNcewAAAAC/cat-thinking.gif\\", \\"title\\": \\"Cat thinking\\", \\"created_at\\": \\"2022-09-25T12:47:45.000000\\", \\"created_by\\": \\"7279197e-0515-4018-9d2b-bc7baff3b4af\\", \\"description\\": \\"Cat thinking\\"}","{\\"id\\": \\"c206be65-9bef-480d-8d0b-d5d8cb76531f\\", \\"url\\": \\"https://c.tenor.com/dDQZ76IRq1UAAAAC/celebration-celebra%C3%A7%C3%A3o.gif\\", \\"title\\": \\"Shaun the Sheep\\", \\"created_at\\": \\"2022-09-25T12:44:56.000000\\", \\"created_by\\": \\"7279197e-0515-4018-9d2b-bc7baff3b4af\\", \\"description\\": \\"Shaun and friends celebrating something\\"}","{\\"id\\": \\"a8864518-d2b9-48a6-adb7-98c9637ab319\\", \\"url\\": \\"https://c.tenor.com/6pyPJTwQTA4AAAAd/september-earth-wind-and-fire.gif\\", \\"title\\": \\"Do you remember\\", \\"created_at\\": \\"2022-09-25T12:42:04.000000\\", \\"created_by\\": \\"7279197e-0515-4018-9d2b-bc7baff3b4af\\", \\"updated_at\\": \\"2022-09-25T12:44:25.000000\\", \\"updated_by\\": \\"7279197e-0515-4018-9d2b-bc7baff3b4af\\", \\"description\\": \\"Someone doing disco\\"}"]	\N	40
8	2022-09-28 01:19:56.316217+00	2022-09-28 01:19:56.316217+00	["{\\"id\\": \\"7279197e-0515-4018-9d2b-bc7baff3b4af\\", \\"email\\": \\"root@innistrad.com\\", \\"active\\": true, \\"username\\": \\"root\\", \\"full_name\\": \\"root\\", \\"created_at\\": \\"2022-09-25T12:35:50.000000\\", \\"phone_number\\": \\"621234567890\\", \\"json_role_ids\\": \\"[]\\", \\"hashed_password\\": \\"$2b$12$8ydH5LesgwUDMdKZ7IGUkuxGn08RaE3PPnOPFsh7WUIPFmdCYSE6e\\", \\"json_permissions\\": \\"[\\\\\\"root\\\\\\"]\\"}"]	\N	46
9	2022-09-28 01:19:56.395234+00	2022-09-28 01:19:56.395234+00	["{\\"id\\": \\"0eca9010-2703-42e1-8445-0c32371762d7\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:15:24.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:15:24.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"1cdae164-6a75-4f2c-96f6-6f89e529c442\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:16:28.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:16:28.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"2c10dfc9-ef8c-4b15-b7dd-4985abbffdbe\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-27T22:53:30.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"fcfa4378-0bcb-4b50-a0f9-0e6f40db4571\\", \\"updated_at\\": \\"2022-09-27T22:53:30.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"42971a74-58e7-4276-9384-c4c1956303e1\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-27T22:54:02.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"fcfa4378-0bcb-4b50-a0f9-0e6f40db4571\\", \\"updated_at\\": \\"2022-09-27T22:54:02.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"6851d1dc-dbe0-4984-be83-a4a32f7956ba\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:17:16.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:17:16.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"75c22e33-73e4-47d8-91aa-e648ba57607f\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:15:08.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:15:08.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"928a55db-4722-4a29-87dd-1be1a1d25998\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:15:56.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:15:56.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"977292b2-1dc7-40c8-a75b-b464219181b5\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:14:37.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:14:37.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"a3a0b3de-6b0e-4172-bc0d-8486fbcf6066\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:14:53.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:14:53.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"d84807d6-7b55-4e28-8656-b29e3f786ddf\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:15:40.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:15:40.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"da279ac3-808e-4cc9-990d-f08edaf83965\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:17:00.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:17:00.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"e37ea7bb-2ecd-4a84-a13f-12af069edaf0\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-27T22:53:47.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"fcfa4378-0bcb-4b50-a0f9-0e6f40db4571\\", \\"updated_at\\": \\"2022-09-27T22:53:47.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"ea64b97f-528f-441b-a424-f72d058543d6\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:16:44.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:16:44.000000\\", \\"updated_by\\": \\"guest\\"}","{\\"id\\": \\"ffec20af-1290-416c-ab2d-5027f1f39b85\\", \\"user_id\\": \\"guest\\", \\"content_id\\": \\"41db1539-bd49-43f4-867c-032fca944443\\", \\"created_at\\": \\"2022-09-28T01:16:12.000000\\", \\"created_by\\": \\"guest\\", \\"session_id\\": \\"cd97441a-d850-48c2-b128-43ff50d41ad2\\", \\"updated_at\\": \\"2022-09-28T01:16:12.000000\\", \\"updated_by\\": \\"guest\\"}"]	\N	49
10	2022-09-28 01:19:56.50411+00	2022-09-28 01:19:56.50411+00	["eb368989c04b"]	\N	53
11	2022-09-28 01:19:56.565461+00	2022-09-28 01:19:56.565461+00	["d56f5d2d08436e8d2b3997c4185d922a"]	\N	55
12	2022-09-28 01:19:56.607791+00	2022-09-28 01:19:56.607791+00	["fb7a94a7-5195-4378-9cae-ccdf7fd3a6a2"]	\N	54
13	2022-09-28 01:19:56.660758+00	2022-09-28 01:19:56.660758+00	["https://c.tenor.com/6pyPJTwQTA4AAAAd/september-earth-wind-and-fire.gif","https://c.tenor.com/dDQZ76IRq1UAAAAC/celebration-celebra%C3%A7%C3%A3o.gif","https://c.tenor.com/JFb7OjmNcewAAAAC/cat-thinking.gif"]	\N	57
14	2022-09-28 01:19:56.747575+00	2022-09-28 01:19:56.747575+00	["Cat thinking","Do you remember","Shaun the Sheep"]	\N	61
15	2022-09-28 01:19:56.775234+00	2022-09-28 01:19:56.775234+00	["7279197e-0515-4018-9d2b-bc7baff3b4af",null]	\N	64
16	2022-09-28 01:19:56.82963+00	2022-09-28 01:19:56.82963+00	["19f9be8ad87d4319676881dfd34c1fa4","69be8d0f15eb2e25ea062c95e146023b","8dd1c99058517f31a79a4a1bf1564580"]	\N	59
17	2022-09-28 01:19:56.880102+00	2022-09-28 01:19:56.880102+00	["Cat thinking","Shaun and friends celebrating something","Someone doing disco"]	\N	60
18	2022-09-28 01:19:56.911794+00	2022-09-28 01:19:56.911794+00	["06a9551e-07b2-426b-a4cd-584ef388710c","34699b2f-e9af-4f07-8b75-8f8a634cfb51","ac442c88-08b1-4840-a70a-b4c69538e6cc"]	\N	63
19	2022-09-28 01:19:57.041493+00	2022-09-28 01:19:57.041493+00	["7279197e-0515-4018-9d2b-bc7baff3b4af"]	\N	68
20	2022-09-28 01:19:57.099274+00	2022-09-28 01:19:57.099274+00	["f94a6a85648664ede0bfbc388e720569"]	\N	94
21	2022-09-28 01:19:57.129362+00	2022-09-28 01:19:57.129362+00	["[]"]	\N	95
22	2022-09-28 01:19:57.163274+00	2022-09-28 01:19:57.163274+00	[null]	\N	96
23	2022-09-28 01:19:57.188413+00	2022-09-28 01:19:57.188413+00	["[\\"root\\"]"]	\N	80
24	2022-09-28 01:19:57.2158+00	2022-09-28 01:19:57.2158+00	["root"]	\N	82
25	2022-09-28 01:19:57.245584+00	2022-09-28 01:19:57.245584+00	["621234567890"]	\N	86
26	2022-09-28 01:19:57.268568+00	2022-09-28 01:19:57.268568+00	["1bef5324-9459-495d-8ca6-b989d0c65ed8"]	\N	88
27	2022-09-28 01:19:57.290732+00	2022-09-28 01:19:57.290732+00	[null]	\N	90
28	2022-09-28 01:19:57.314459+00	2022-09-28 01:19:57.314459+00	["$2b$12$8ydH5LesgwUDMdKZ7IGUkuxGn08RaE3PPnOPFsh7WUIPFmdCYSE6e"]	\N	81
29	2022-09-28 01:19:57.337652+00	2022-09-28 01:19:57.337652+00	[true]	\N	83
30	2022-09-28 01:19:57.369475+00	2022-09-28 01:19:57.369475+00	["root@innistrad.com"]	\N	85
31	2022-09-28 01:19:57.392679+00	2022-09-28 01:19:57.392679+00	["root"]	\N	89
32	2022-09-28 01:19:57.426428+00	2022-09-28 01:19:57.426428+00	["41db1539-bd49-43f4-867c-032fca944443"]	\N	97
33	2022-09-28 01:19:57.454418+00	2022-09-28 01:19:57.454418+00	["guest"]	\N	99
34	2022-09-28 01:19:57.478957+00	2022-09-28 01:19:57.478957+00	["0559b9b5-6b6c-4b11-bad4-072fb6adb0e6","07139de0-437c-4e0b-bff9-022fe154fd35","13f3c2ec-6f1d-4da2-911c-468ddf6d9546","1b614a2d-e3d8-4660-a64c-b86c0a074849","64ed5ce7-5e87-49f5-ad2e-4070bdcf9f78","6a539658-ae73-4e4d-b1be-791c02137001","9ca29248-2f02-46f0-8a2b-735f84e45987","a4ac92c2-212a-40ca-aeeb-c2efdca4f156","b27f88c0-21cb-4528-b911-279c21fbc995","c0c12f02-64e1-46a0-b266-411b45c0c252","c9e5f808-5c88-4a8a-9512-de43bc2025a9","e04864d2-06e5-4c48-bb06-7b2709beedc3","e2d78391-e81d-4ebf-9099-847dd00f12e3","e79b7917-146b-4a73-bfe4-6294fe54f37d"]	\N	102
35	2022-09-28 01:19:57.497801+00	2022-09-28 01:19:57.497801+00	["cd97441a-d850-48c2-b128-43ff50d41ad2","fcfa4378-0bcb-4b50-a0f9-0e6f40db4571"]	\N	105
36	2022-09-28 01:19:57.515662+00	2022-09-28 01:19:57.515662+00	["guest"]	\N	108
37	2022-09-28 01:19:57.54386+00	2022-09-28 01:19:57.54386+00	["46c58ed0589f3f0ca98b1be888db7330","4fd3877431613f87cd851ff6fef08d41","5f172f3d79fe94cade2d7c09fbced89f","7cd69c664b5666aa6e1d71b7c406db9c","82814cc842c622a4764d7cf9faed0b48","8536c55f8013d4f6e152298e10de26bc","8bcf01a1c55bf2cceb57aeb8a80c2c08","995013e28de2e21a8d4fcbab00c95861","a017737d72f51fafd814b6bf9970b991","a94a47d1630884e724b3269ef0da7fb7","b74f3fef2f14a0a47ed59c78a4ed1912","c22553d5f319ea2833ba34cc8d242e93","d68d6915187b110e4e524181f2d86585","f9e34e01e00eeddb356dec07aa3516e2"]	\N	98
38	2022-09-28 01:19:57.56136+00	2022-09-28 01:19:57.56136+00	["guest"]	\N	103
\.


--
-- Data for Name: metabase_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_table (id, created_at, updated_at, name, rows, description, entity_name, entity_type, active, db_id, display_name, visibility_type, schema, points_of_interest, caveats, show_in_getting_started, fields_hash) FROM stdin;
2	2022-09-28 00:52:05.059234+00	2022-09-28 00:52:10.007368+00	ORDERS	\N	This is a confirmed order for a product from a user.	\N	entity/TransactionTable	t	1	Orders	\N	PUBLIC	\N	\N	f	Iqz4vNbm7vh80Uo9pWdesA==
3	2022-09-28 00:52:05.064943+00	2022-09-28 00:52:10.009884+00	PEOPLE	\N	This is a user account. Note that employees and customer support staff will have accounts.	\N	entity/UserTable	t	1	People	\N	PUBLIC	\N	\N	f	CXKI5VefRbNYgZ8IStmaNw==
1	2022-09-28 00:52:05.049042+00	2022-09-28 00:52:10.013581+00	PRODUCTS	\N	This is our product catalog. It includes all products ever sold by the Sample Company.	\N	entity/ProductTable	t	1	Products	\N	PUBLIC	\N	\N	f	aqXlpsb4FjyCH5o8qP4a2A==
4	2022-09-28 00:52:05.071252+00	2022-09-28 00:52:10.020231+00	REVIEWS	\N	These are reviews our customers have left on products. Note that these are not tied to orders so it is possible people have reviewed products they did not purchase from us.	\N	entity/GenericTable	t	1	Reviews	\N	PUBLIC	\N	\N	f	wIcr7cLnXrbpAUfOXgcmeQ==
13	2022-09-28 01:19:53.950336+00	2022-09-28 01:19:56.108182+00	_airbyte_raw_alembic_version	\N	\N	\N	entity/GenericTable	t	2	Air Byte Raw Alembic Version	\N	sample	\N	\N	f	CiPv8qAdnnvYfzqljHRp0w==
12	2022-09-28 01:19:53.944517+00	2022-09-28 01:19:56.111735+00	_airbyte_raw_contents	\N	\N	\N	entity/GenericTable	t	2	Air Byte Raw Contents	\N	sample	\N	\N	f	CiPv8qAdnnvYfzqljHRp0w==
8	2022-09-28 01:19:53.922622+00	2022-09-28 01:19:56.114978+00	_airbyte_raw_roles	\N	\N	\N	entity/GenericTable	t	2	Air Byte Raw Roles	\N	sample	\N	\N	f	CiPv8qAdnnvYfzqljHRp0w==
11	2022-09-28 01:19:53.938551+00	2022-09-28 01:19:56.117184+00	_airbyte_raw_users	\N	\N	\N	entity/UserTable	t	2	Air Byte Raw Users	\N	sample	\N	\N	f	CiPv8qAdnnvYfzqljHRp0w==
10	2022-09-28 01:19:53.931743+00	2022-09-28 01:19:56.121329+00	_airbyte_raw_views	\N	\N	\N	entity/GenericTable	t	2	Air Byte Raw Views	\N	sample	\N	\N	f	CiPv8qAdnnvYfzqljHRp0w==
5	2022-09-28 01:19:53.899818+00	2022-09-28 01:19:56.124325+00	alembic_version	\N	\N	\N	entity/GenericTable	t	2	Alembic Version	\N	sample	\N	\N	f	IsvBU1YS7IjEko3ihQMtzw==
6	2022-09-28 01:19:53.911301+00	2022-09-28 01:19:56.127153+00	contents	\N	\N	\N	entity/GenericTable	t	2	Contents	\N	sample	\N	\N	f	h6/b11GFgIv8ULaxTLAJ8w==
9	2022-09-28 01:19:53.927282+00	2022-09-28 01:19:56.130486+00	roles	\N	\N	\N	entity/GenericTable	t	2	Roles	\N	sample	\N	\N	f	KtNxXlzfxruFBp3fFBgHDw==
7	2022-09-28 01:19:53.916428+00	2022-09-28 01:19:56.133715+00	users	\N	\N	\N	entity/UserTable	t	2	Users	\N	sample	\N	\N	f	/ymYTQCwVNyLcP1wkJxBAQ==
14	2022-09-28 01:19:53.953981+00	2022-09-28 01:19:56.137307+00	views	\N	\N	\N	entity/GenericTable	t	2	Views	\N	sample	\N	\N	f	GLjbbgsxTe2clnXxYv0ymg==
\.


--
-- Data for Name: metric; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metric (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, how_is_this_calculated, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: metric_important_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metric_important_field (id, metric_id, field_id) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, object, group_id) FROM stdin;
1	/	2
2	/collection/root/	1
3	/collection/root/	3
4	/db/1/	1
5	/db/2/	1
\.


--
-- Data for Name: permissions_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_group (id, name) FROM stdin;
1	All Users
2	Administrators
3	MetaBot
\.


--
-- Data for Name: permissions_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_group_membership (id, user_id, group_id) FROM stdin;
1	1	1
2	1	2
\.


--
-- Data for Name: permissions_revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_revision (id, before, after, user_id, created_at, remark) FROM stdin;
\.


--
-- Data for Name: pulse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse (id, creator_id, name, created_at, updated_at, skip_if_empty, alert_condition, alert_first_only, alert_above_goal, collection_id, collection_position, archived) FROM stdin;
\.


--
-- Data for Name: pulse_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_card (id, pulse_id, card_id, "position", include_csv, include_xls) FROM stdin;
\.


--
-- Data for Name: pulse_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_channel (id, pulse_id, channel_type, details, schedule_type, schedule_hour, schedule_day, created_at, updated_at, schedule_frame, enabled) FROM stdin;
\.


--
-- Data for Name: pulse_channel_recipient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_channel_recipient (id, pulse_channel_id, user_id) FROM stdin;
\.


--
-- Data for Name: qrtz_blob_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_blob_triggers (sched_name, trigger_name, trigger_group, blob_data) FROM stdin;
\.


--
-- Data for Name: qrtz_calendars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_calendars (sched_name, calendar_name, calendar) FROM stdin;
\.


--
-- Data for Name: qrtz_cron_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_cron_triggers (sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) FROM stdin;
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	0 50 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	0 50 0 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	0 15 6,18 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	0 15 7 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	0 0 12 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	0 0 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	0 0 12 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	0 0 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	0 50 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	0 50 0 * * ? *	Asia/Jakarta
\.


--
-- Data for Name: qrtz_fired_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_fired_triggers (sched_name, entry_id, trigger_name, trigger_group, instance_name, fired_time, sched_time, priority, state, job_name, job_group, is_nonconcurrent, requests_recovery) FROM stdin;
\.


--
-- Data for Name: qrtz_job_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_job_details (sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) FROM stdin;
MetabaseScheduler	metabase.task.upgrade-checks.job	DEFAULT	\N	metabase.task.upgrade_checks.CheckForNewVersions	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.anonymous-stats.job	DEFAULT	\N	metabase.task.send_anonymous_stats.SendAnonymousUsageStats	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.abandonment-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.AbandonmentEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.send-pulses.job	DEFAULT	\N	metabase.task.send_pulses.SendPulses	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.follow-up-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.FollowUpEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.task-history-cleanup.job	DEFAULT	\N	metabase.task.task_history_cleanup.TaskHistoryCleanup	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze for all databases	metabase.task.sync_databases.SyncAndAnalyzeDatabase	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.update-field-values.job	DEFAULT	update-field-values for all databases	metabase.task.sync_databases.UpdateFieldValues	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
\.


--
-- Data for Name: qrtz_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_locks (sched_name, lock_name) FROM stdin;
MetabaseScheduler	STATE_ACCESS
MetabaseScheduler	TRIGGER_ACCESS
\.


--
-- Data for Name: qrtz_paused_trigger_grps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_paused_trigger_grps (sched_name, trigger_group) FROM stdin;
\.


--
-- Data for Name: qrtz_scheduler_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_scheduler_state (sched_name, instance_name, last_checkin_time, checkin_interval) FROM stdin;
MetabaseScheduler	metabase1664327356479	1664328129300	7500
\.


--
-- Data for Name: qrtz_simple_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_simple_triggers (sched_name, trigger_name, trigger_group, repeat_count, repeat_interval, times_triggered) FROM stdin;
\.


--
-- Data for Name: qrtz_simprop_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_simprop_triggers (sched_name, trigger_name, trigger_group, str_prop_1, str_prop_2, str_prop_3, int_prop_1, int_prop_2, long_prop_1, long_prop_2, dec_prop_1, dec_prop_2, bool_prop_1, bool_prop_2) FROM stdin;
\.


--
-- Data for Name: qrtz_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_triggers (sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) FROM stdin;
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 1	1664329800000	-1	5	WAITING	CRON	1664327356000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 1	1664387400000	-1	5	WAITING	CRON	1664327356000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	metabase.task.upgrade-checks.job	DEFAULT	\N	1664363700000	-1	5	WAITING	CRON	1664327356000	0	\N	0	\\x
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	metabase.task.anonymous-stats.job	DEFAULT	\N	1664410500000	-1	5	WAITING	CRON	1664327356000	0	\N	0	\\x
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	metabase.task.abandonment-emails.job	DEFAULT	\N	1664341200000	-1	5	WAITING	CRON	1664327356000	0	\N	0	\\x
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	metabase.task.send-pulses.job	DEFAULT	\N	1664330400000	-1	5	WAITING	CRON	1664327356000	0	\N	1	\\x
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	metabase.task.follow-up-emails.job	DEFAULT	\N	1664341200000	-1	5	WAITING	CRON	1664327356000	0	\N	0	\\x
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	metabase.task.task-history-cleanup.job	DEFAULT	\N	1664330400000	-1	5	WAITING	CRON	1664327356000	0	\N	0	\\x
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 2	1664329800000	-1	5	WAITING	CRON	1664327993000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 2	1664387400000	-1	5	WAITING	CRON	1664327993000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
\.


--
-- Data for Name: query; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query (query_hash, average_execution_time, query) FROM stdin;
\.


--
-- Data for Name: query_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_cache (query_hash, updated_at, results) FROM stdin;
\.


--
-- Data for Name: query_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_execution (id, hash, started_at, running_time, result_rows, native, context, error, executor_id, card_id, dashboard_id, pulse_id, database_id) FROM stdin;
\.


--
-- Data for Name: report_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_card (id, created_at, updated_at, name, description, display, dataset_query, visualization_settings, creator_id, database_id, table_id, query_type, archived, collection_id, public_uuid, made_public_by_id, enable_embedding, embedding_params, cache_ttl, result_metadata, read_permissions, collection_position) FROM stdin;
\.


--
-- Data for Name: report_cardfavorite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_cardfavorite (id, created_at, updated_at, card_id, owner_id) FROM stdin;
\.


--
-- Data for Name: report_dashboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_dashboard (id, created_at, updated_at, name, description, creator_id, parameters, points_of_interest, caveats, show_in_getting_started, public_uuid, made_public_by_id, enable_embedding, embedding_params, archived, "position", collection_id, collection_position) FROM stdin;
\.


--
-- Data for Name: report_dashboardcard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_dashboardcard (id, created_at, updated_at, "sizeX", "sizeY", "row", col, card_id, dashboard_id, parameter_mappings, visualization_settings) FROM stdin;
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision (id, model, model_id, user_id, "timestamp", object, is_reversion, is_creation, message) FROM stdin;
\.


--
-- Data for Name: segment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.segment (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: setting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.setting (key, value) FROM stdin;
site-url	http://localhost:3001
site-name	state-alchemists
admin-email	gofrendiasgard@gmail.com
anon-tracking-enabled	false
settings-last-updated	2022-09-28 08:19:53.692419+07
\.


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_history (id, task, db_id, started_at, ended_at, duration, task_details) FROM stdin;
1	sync	1	2022-09-28 07:52:04.63337	2022-09-28 07:52:05.626135	992	\N
2	sync-timezone	1	2022-09-28 07:52:04.634136	2022-09-28 07:52:04.985208	351	{"timezone-id":"Asia/Jakarta"}
3	sync-tables	1	2022-09-28 07:52:04.985897	2022-09-28 07:52:05.079818	93	{"updated-tables":4,"total-tables":0}
4	sync-fields	1	2022-09-28 07:52:05.079962	2022-09-28 07:52:05.415076	335	{"total-fields":36,"updated-fields":36}
5	sync-fks	1	2022-09-28 07:52:05.415148	2022-09-28 07:52:05.453943	38	{"total-fks":3,"updated-fks":3,"total-failed":0}
6	sync-metabase-metadata	1	2022-09-28 07:52:05.454026	2022-09-28 07:52:05.626092	172	\N
7	analyze	1	2022-09-28 07:52:05.6907	2022-09-28 07:52:10.022925	4332	\N
8	fingerprint-fields	1	2022-09-28 07:52:05.69073	2022-09-28 07:52:09.866285	4175	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":32,"fingerprints-attempted":32}
9	classify-fields	1	2022-09-28 07:52:09.866363	2022-09-28 07:52:10.001007	134	{"fields-classified":32,"fields-failed":0}
10	classify-tables	1	2022-09-28 07:52:10.001104	2022-09-28 07:52:10.022814	21	{"total-tables":4,"tables-classified":4}
11	field values scanning	1	2022-09-28 07:52:10.040588	2022-09-28 07:52:10.645361	604	\N
12	update-field-values	1	2022-09-28 07:52:10.040735	2022-09-28 07:52:10.645305	604	{"errors":0,"created":5,"updated":0,"deleted":0}
13	task-history-cleanup	\N	2022-09-28 08:00:00.027	2022-09-28 08:00:00.03	3	\N
14	send-pulses	\N	2022-09-28 08:00:00.016	2022-09-28 08:00:00.03	14	\N
15	sync	2	2022-09-28 08:19:53.708029	2022-09-28 08:19:54.760847	1052	\N
16	sync-timezone	2	2022-09-28 08:19:53.709543	2022-09-28 08:19:53.836526	126	{"timezone-id":"Asia/Jakarta"}
17	sync-tables	2	2022-09-28 08:19:53.837053	2022-09-28 08:19:53.96126	124	{"updated-tables":10,"total-tables":0}
18	sync-fields	2	2022-09-28 08:19:53.961419	2022-09-28 08:19:54.620669	659	{"total-fields":72,"updated-fields":72}
19	sync-fks	2	2022-09-28 08:19:54.620772	2022-09-28 08:19:54.744299	123	{"total-fks":0,"updated-fks":0,"total-failed":0}
20	sync-metabase-metadata	2	2022-09-28 08:19:54.744426	2022-09-28 08:19:54.760784	16	\N
21	analyze	2	2022-09-28 08:19:54.8435	2022-09-28 08:19:56.139563	1296	\N
22	fingerprint-fields	2	2022-09-28 08:19:54.843533	2022-09-28 08:19:55.89036	1046	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":55,"fingerprints-attempted":67}
23	classify-fields	2	2022-09-28 08:19:55.890433	2022-09-28 08:19:56.103218	212	{"fields-classified":55,"fields-failed":0}
24	classify-tables	2	2022-09-28 08:19:56.103298	2022-09-28 08:19:56.139463	36	{"total-tables":10,"tables-classified":10}
25	field values scanning	2	2022-09-28 08:19:56.156235	2022-09-28 08:19:57.563942	1407	\N
26	update-field-values	2	2022-09-28 08:19:56.156271	2022-09-28 08:19:57.563881	1407	{"errors":0,"created":33,"updated":0,"deleted":0}
\.


--
-- Data for Name: view_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_log (id, user_id, model, model_id, "timestamp") FROM stdin;
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_id_seq', 2, true);


--
-- Name: card_label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.card_label_id_seq', 1, false);


--
-- Name: collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_id_seq', 1, true);


--
-- Name: collection_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_revision_id_seq', 1, false);


--
-- Name: computation_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computation_job_id_seq', 1, false);


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computation_job_result_id_seq', 1, false);


--
-- Name: core_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_user_id_seq', 1, true);


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboard_favorite_id_seq', 1, false);


--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboardcard_series_id_seq', 1, false);


--
-- Name: dependency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dependency_id_seq', 1, false);


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dimension_id_seq', 1, false);


--
-- Name: label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.label_id_seq', 1, false);


--
-- Name: metabase_database_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_database_id_seq', 2, true);


--
-- Name: metabase_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_field_id_seq', 108, true);


--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_fieldvalues_id_seq', 38, true);


--
-- Name: metabase_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_table_id_seq', 14, true);


--
-- Name: metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metric_id_seq', 1, false);


--
-- Name: metric_important_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metric_important_field_id_seq', 1, false);


--
-- Name: permissions_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_group_id_seq', 3, true);


--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_group_membership_id_seq', 2, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 5, true);


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_revision_id_seq', 1, false);


--
-- Name: pulse_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_card_id_seq', 1, false);


--
-- Name: pulse_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_channel_id_seq', 1, false);


--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_channel_recipient_id_seq', 1, false);


--
-- Name: pulse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_id_seq', 1, false);


--
-- Name: query_execution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_execution_id_seq', 1, false);


--
-- Name: report_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_card_id_seq', 1, false);


--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_cardfavorite_id_seq', 1, false);


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboard_id_seq', 1, false);


--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboardcard_id_seq', 1, false);


--
-- Name: revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revision_id_seq', 1, false);


--
-- Name: segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.segment_id_seq', 1, false);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_history_id_seq', 26, true);


--
-- Name: view_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.view_log_id_seq', 1, false);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: card_label card_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT card_label_pkey PRIMARY KEY (id);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: collection_revision collection_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT collection_revision_pkey PRIMARY KEY (id);


--
-- Name: computation_job computation_job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT computation_job_pkey PRIMARY KEY (id);


--
-- Name: computation_job_result computation_job_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT computation_job_result_pkey PRIMARY KEY (id);


--
-- Name: core_session core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT core_session_pkey PRIMARY KEY (id);


--
-- Name: core_user core_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_email_key UNIQUE (email);


--
-- Name: core_user core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_pkey PRIMARY KEY (id);


--
-- Name: dashboard_favorite dashboard_favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT dashboard_favorite_pkey PRIMARY KEY (id);


--
-- Name: dashboardcard_series dashboardcard_series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT dashboardcard_series_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: dependency dependency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependency
    ADD CONSTRAINT dependency_pkey PRIMARY KEY (id);


--
-- Name: dimension dimension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT dimension_pkey PRIMARY KEY (id);


--
-- Name: databasechangelog idx_databasechangelog_id_author_filename; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangelog
    ADD CONSTRAINT idx_databasechangelog_id_author_filename UNIQUE (id, author, filename);


--
-- Name: metabase_field idx_uniq_field_table_id_parent_id_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT idx_uniq_field_table_id_parent_id_name UNIQUE (table_id, parent_id, name);


--
-- Name: metabase_table idx_uniq_table_db_id_schema_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT idx_uniq_table_db_id_schema_name UNIQUE (db_id, schema, name);


--
-- Name: report_cardfavorite idx_unique_cardfavorite_card_id_owner_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT idx_unique_cardfavorite_card_id_owner_id UNIQUE (card_id, owner_id);


--
-- Name: label label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);


--
-- Name: label label_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_slug_key UNIQUE (slug);


--
-- Name: metabase_database metabase_database_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_database
    ADD CONSTRAINT metabase_database_pkey PRIMARY KEY (id);


--
-- Name: metabase_field metabase_field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT metabase_field_pkey PRIMARY KEY (id);


--
-- Name: metabase_fieldvalues metabase_fieldvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT metabase_fieldvalues_pkey PRIMARY KEY (id);


--
-- Name: metabase_table metabase_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT metabase_table_pkey PRIMARY KEY (id);


--
-- Name: metric_important_field metric_important_field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT metric_important_field_pkey PRIMARY KEY (id);


--
-- Name: metric metric_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT metric_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_group_id_object_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_group_id_object_key UNIQUE (group_id, object);


--
-- Name: permissions_group_membership permissions_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT permissions_group_membership_pkey PRIMARY KEY (id);


--
-- Name: permissions_group permissions_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT permissions_group_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: permissions_revision permissions_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT permissions_revision_pkey PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers pk_qrtz_blob_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT pk_qrtz_blob_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_calendars pk_qrtz_calendars; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT pk_qrtz_calendars PRIMARY KEY (sched_name, calendar_name);


--
-- Name: qrtz_cron_triggers pk_qrtz_cron_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT pk_qrtz_cron_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers pk_qrtz_fired_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT pk_qrtz_fired_triggers PRIMARY KEY (sched_name, entry_id);


--
-- Name: qrtz_job_details pk_qrtz_job_details; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT pk_qrtz_job_details PRIMARY KEY (sched_name, job_name, job_group);


--
-- Name: qrtz_locks pk_qrtz_locks; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT pk_qrtz_locks PRIMARY KEY (sched_name, lock_name);


--
-- Name: qrtz_scheduler_state pk_qrtz_scheduler_state; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT pk_qrtz_scheduler_state PRIMARY KEY (sched_name, instance_name);


--
-- Name: qrtz_simple_triggers pk_qrtz_simple_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT pk_qrtz_simple_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers pk_qrtz_simprop_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT pk_qrtz_simprop_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers pk_qrtz_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT pk_qrtz_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_paused_trigger_grps pk_sched_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT pk_sched_name PRIMARY KEY (sched_name, trigger_group);


--
-- Name: pulse_card pulse_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT pulse_card_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel pulse_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT pulse_channel_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel_recipient pulse_channel_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT pulse_channel_recipient_pkey PRIMARY KEY (id);


--
-- Name: pulse pulse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT pulse_pkey PRIMARY KEY (id);


--
-- Name: query_cache query_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_cache
    ADD CONSTRAINT query_cache_pkey PRIMARY KEY (query_hash);


--
-- Name: query_execution query_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_execution
    ADD CONSTRAINT query_execution_pkey PRIMARY KEY (id);


--
-- Name: query query_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_pkey PRIMARY KEY (query_hash);


--
-- Name: report_card report_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_pkey PRIMARY KEY (id);


--
-- Name: report_card report_card_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_cardfavorite report_cardfavorite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT report_cardfavorite_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_dashboardcard report_dashboardcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT report_dashboardcard_pkey PRIMARY KEY (id);


--
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (id);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (key);


--
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- Name: card_label unique_card_label_card_id_label_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT unique_card_label_card_id_label_id UNIQUE (card_id, label_id);


--
-- Name: collection unique_collection_personal_owner_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT unique_collection_personal_owner_id UNIQUE (personal_owner_id);


--
-- Name: dashboard_favorite unique_dashboard_favorite_user_id_dashboard_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT unique_dashboard_favorite_user_id_dashboard_id UNIQUE (user_id, dashboard_id);


--
-- Name: dimension unique_dimension_field_id_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT unique_dimension_field_id_name UNIQUE (field_id, name);


--
-- Name: metric_important_field unique_metric_important_field_metric_id_field_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT unique_metric_important_field_metric_id_field_id UNIQUE (metric_id, field_id);


--
-- Name: permissions_group_membership unique_permissions_group_membership_user_id_group_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT unique_permissions_group_membership_user_id_group_id UNIQUE (user_id, group_id);


--
-- Name: permissions_group unique_permissions_group_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT unique_permissions_group_name UNIQUE (name);


--
-- Name: view_log view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT view_log_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_custom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_custom_id ON public.activity USING btree (custom_id);


--
-- Name: idx_activity_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_timestamp ON public.activity USING btree ("timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_user_id ON public.activity USING btree (user_id);


--
-- Name: idx_card_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_collection_id ON public.report_card USING btree (collection_id);


--
-- Name: idx_card_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_creator_id ON public.report_card USING btree (creator_id);


--
-- Name: idx_card_label_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_label_card_id ON public.card_label USING btree (card_id);


--
-- Name: idx_card_label_label_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_label_label_id ON public.card_label USING btree (label_id);


--
-- Name: idx_card_public_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_public_uuid ON public.report_card USING btree (public_uuid);


--
-- Name: idx_cardfavorite_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cardfavorite_card_id ON public.report_cardfavorite USING btree (card_id);


--
-- Name: idx_cardfavorite_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cardfavorite_owner_id ON public.report_cardfavorite USING btree (owner_id);


--
-- Name: idx_collection_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_collection_location ON public.collection USING btree (location);


--
-- Name: idx_collection_personal_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_collection_personal_owner_id ON public.collection USING btree (personal_owner_id);


--
-- Name: idx_dashboard_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_collection_id ON public.report_dashboard USING btree (collection_id);


--
-- Name: idx_dashboard_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_creator_id ON public.report_dashboard USING btree (creator_id);


--
-- Name: idx_dashboard_favorite_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_favorite_dashboard_id ON public.dashboard_favorite USING btree (dashboard_id);


--
-- Name: idx_dashboard_favorite_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_favorite_user_id ON public.dashboard_favorite USING btree (user_id);


--
-- Name: idx_dashboard_public_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_public_uuid ON public.report_dashboard USING btree (public_uuid);


--
-- Name: idx_dashboardcard_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_card_id ON public.report_dashboardcard USING btree (card_id);


--
-- Name: idx_dashboardcard_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_dashboard_id ON public.report_dashboardcard USING btree (dashboard_id);


--
-- Name: idx_dashboardcard_series_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_series_card_id ON public.dashboardcard_series USING btree (card_id);


--
-- Name: idx_dashboardcard_series_dashboardcard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_series_dashboardcard_id ON public.dashboardcard_series USING btree (dashboardcard_id);


--
-- Name: idx_data_migrations_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data_migrations_id ON public.data_migrations USING btree (id);


--
-- Name: idx_dependency_dependent_on_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_dependent_on_id ON public.dependency USING btree (dependent_on_id);


--
-- Name: idx_dependency_dependent_on_model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_dependent_on_model ON public.dependency USING btree (dependent_on_model);


--
-- Name: idx_dependency_model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_model ON public.dependency USING btree (model);


--
-- Name: idx_dependency_model_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_model_id ON public.dependency USING btree (model_id);


--
-- Name: idx_dimension_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dimension_field_id ON public.dimension USING btree (field_id);


--
-- Name: idx_field_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_field_parent_id ON public.metabase_field USING btree (parent_id);


--
-- Name: idx_field_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_field_table_id ON public.metabase_field USING btree (table_id);


--
-- Name: idx_fieldvalues_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fieldvalues_field_id ON public.metabase_fieldvalues USING btree (field_id);


--
-- Name: idx_label_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_label_slug ON public.label USING btree (slug);


--
-- Name: idx_metabase_table_db_id_schema; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metabase_table_db_id_schema ON public.metabase_table USING btree (db_id, schema);


--
-- Name: idx_metabase_table_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metabase_table_show_in_getting_started ON public.metabase_table USING btree (show_in_getting_started);


--
-- Name: idx_metric_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_creator_id ON public.metric USING btree (creator_id);


--
-- Name: idx_metric_important_field_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_important_field_field_id ON public.metric_important_field USING btree (field_id);


--
-- Name: idx_metric_important_field_metric_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_important_field_metric_id ON public.metric_important_field USING btree (metric_id);


--
-- Name: idx_metric_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_show_in_getting_started ON public.metric USING btree (show_in_getting_started);


--
-- Name: idx_metric_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_table_id ON public.metric USING btree (table_id);


--
-- Name: idx_permissions_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_id ON public.permissions USING btree (group_id);


--
-- Name: idx_permissions_group_id_object; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_id_object ON public.permissions USING btree (group_id, object);


--
-- Name: idx_permissions_group_membership_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_group_id ON public.permissions_group_membership USING btree (group_id);


--
-- Name: idx_permissions_group_membership_group_id_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_group_id_user_id ON public.permissions_group_membership USING btree (group_id, user_id);


--
-- Name: idx_permissions_group_membership_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_user_id ON public.permissions_group_membership USING btree (user_id);


--
-- Name: idx_permissions_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_name ON public.permissions_group USING btree (name);


--
-- Name: idx_permissions_object; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_object ON public.permissions USING btree (object);


--
-- Name: idx_pulse_card_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_card_card_id ON public.pulse_card USING btree (card_id);


--
-- Name: idx_pulse_card_pulse_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_card_pulse_id ON public.pulse_card USING btree (pulse_id);


--
-- Name: idx_pulse_channel_pulse_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_channel_pulse_id ON public.pulse_channel USING btree (pulse_id);


--
-- Name: idx_pulse_channel_schedule_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_channel_schedule_type ON public.pulse_channel USING btree (schedule_type);


--
-- Name: idx_pulse_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_collection_id ON public.pulse USING btree (collection_id);


--
-- Name: idx_pulse_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_creator_id ON public.pulse USING btree (creator_id);


--
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON public.qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_j_g ON public.qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_jg ON public.qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_t_g ON public.qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_tg ON public.qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_trig_inst_name ON public.qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_j_grp ON public.qrtz_job_details USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_j_req_recovery ON public.qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_c ON public.qrtz_triggers USING btree (sched_name, calendar_name);


--
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_g ON public.qrtz_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_j ON public.qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_jg ON public.qrtz_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_n_g_state ON public.qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_n_state ON public.qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_next_fire_time ON public.qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st ON public.qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_state ON public.qrtz_triggers USING btree (sched_name, trigger_state);


--
-- Name: idx_query_cache_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_cache_updated_at ON public.query_cache USING btree (updated_at);


--
-- Name: idx_query_execution_query_hash_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_query_hash_started_at ON public.query_execution USING btree (hash, started_at);


--
-- Name: idx_query_execution_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_started_at ON public.query_execution USING btree (started_at);


--
-- Name: idx_report_dashboard_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_report_dashboard_show_in_getting_started ON public.report_dashboard USING btree (show_in_getting_started);


--
-- Name: idx_revision_model_model_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revision_model_model_id ON public.revision USING btree (model, model_id);


--
-- Name: idx_segment_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_creator_id ON public.segment USING btree (creator_id);


--
-- Name: idx_segment_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_show_in_getting_started ON public.segment USING btree (show_in_getting_started);


--
-- Name: idx_segment_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_table_id ON public.segment USING btree (table_id);


--
-- Name: idx_table_db_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_table_db_id ON public.metabase_table USING btree (db_id);


--
-- Name: idx_task_history_db_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_history_db_id ON public.task_history USING btree (db_id);


--
-- Name: idx_task_history_end_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_history_end_time ON public.task_history USING btree (ended_at);


--
-- Name: idx_uniq_field_table_id_parent_id_name_2col; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_uniq_field_table_id_parent_id_name_2col ON public.metabase_field USING btree (table_id, name) WHERE (parent_id IS NULL);


--
-- Name: idx_uniq_table_db_id_schema_name_2col; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_uniq_table_db_id_schema_name_2col ON public.metabase_table USING btree (db_id, name) WHERE (schema IS NULL);


--
-- Name: idx_view_log_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_view_log_timestamp ON public.view_log USING btree (model_id);


--
-- Name: idx_view_log_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_view_log_user_id ON public.view_log USING btree (user_id);


--
-- Name: activity fk_activity_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT fk_activity_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: report_card fk_card_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: card_label fk_card_label_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: card_label fk_card_label_ref_label_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_label_id FOREIGN KEY (label_id) REFERENCES public.label(id);


--
-- Name: report_card fk_card_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id);


--
-- Name: report_card fk_card_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: report_cardfavorite fk_cardfavorite_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: report_cardfavorite fk_cardfavorite_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_user_id FOREIGN KEY (owner_id) REFERENCES public.core_user(id);


--
-- Name: collection fk_collection_personal_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT fk_collection_personal_owner_id FOREIGN KEY (personal_owner_id) REFERENCES public.core_user(id);


--
-- Name: collection_revision fk_collection_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT fk_collection_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: computation_job fk_computation_job_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT fk_computation_job_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: computation_job_result fk_computation_result_ref_job_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT fk_computation_result_ref_job_id FOREIGN KEY (job_id) REFERENCES public.computation_job(id);


--
-- Name: report_dashboard fk_dashboard_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: dashboard_favorite fk_dashboard_favorite_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboard_favorite fk_dashboard_favorite_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id);


--
-- Name: report_dashboard fk_dashboard_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: report_dashboardcard fk_dashboardcard_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: report_dashboardcard fk_dashboardcard_ref_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id);


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_dashboardcard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_dashboardcard_id FOREIGN KEY (dashboardcard_id) REFERENCES public.report_dashboardcard(id);


--
-- Name: dimension fk_dimension_displayfk_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_displayfk_ref_field_id FOREIGN KEY (human_readable_field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_parent_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_parent_ref_field_id FOREIGN KEY (parent_id) REFERENCES public.metabase_field(id);


--
-- Name: metabase_field fk_field_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: metabase_fieldvalues fk_fieldvalues_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT fk_fieldvalues_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id);


--
-- Name: metric_important_field fk_metric_important_field_metabase_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metabase_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id);


--
-- Name: metric_important_field fk_metric_important_field_metric_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metric_id FOREIGN KEY (metric_id) REFERENCES public.metric(id);


--
-- Name: metric fk_metric_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: metric fk_metric_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: permissions_group_membership fk_permissions_group_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id);


--
-- Name: permissions fk_permissions_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT fk_permissions_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id);


--
-- Name: permissions_group_membership fk_permissions_group_membership_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_membership_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: permissions_revision fk_permissions_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT fk_permissions_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: pulse_card fk_pulse_card_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id);


--
-- Name: pulse_card fk_pulse_card_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id);


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_pulse_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_pulse_channel_id FOREIGN KEY (pulse_channel_id) REFERENCES public.pulse_channel(id);


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: pulse_channel fk_pulse_channel_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT fk_pulse_channel_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id);


--
-- Name: pulse fk_pulse_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id);


--
-- Name: pulse fk_pulse_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: qrtz_blob_triggers fk_qrtz_blob_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT fk_qrtz_blob_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers fk_qrtz_cron_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT fk_qrtz_cron_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simple_triggers fk_qrtz_simple_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT fk_qrtz_simple_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers fk_qrtz_simprop_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT fk_qrtz_simprop_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers fk_qrtz_triggers_job_details; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT fk_qrtz_triggers_job_details FOREIGN KEY (sched_name, job_name, job_group) REFERENCES public.qrtz_job_details(sched_name, job_name, job_group);


--
-- Name: report_card fk_report_card_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_database_id FOREIGN KEY (database_id) REFERENCES public.metabase_database(id);


--
-- Name: report_card fk_report_card_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: revision fk_revision_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT fk_revision_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: segment fk_segment_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id);


--
-- Name: segment fk_segment_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id);


--
-- Name: core_session fk_session_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT fk_session_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- Name: metabase_table fk_table_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT fk_table_ref_database_id FOREIGN KEY (db_id) REFERENCES public.metabase_database(id);


--
-- Name: view_log fk_view_log_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT fk_view_log_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id);


--
-- PostgreSQL database dump complete
--

