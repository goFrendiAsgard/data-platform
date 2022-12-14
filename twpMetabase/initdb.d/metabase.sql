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
3	card-create	2022-09-28 15:57:16.366686+00	1	card	1	2	15	\N	{"name":"Global Content Views","description":null}
4	dashboard-create	2022-09-28 15:57:48.401+00	1	dashboard	1	\N	\N	\N	{"description":"Global Content View","name":"Global Content View"}
5	dashboard-add-cards	2022-09-28 15:57:55.142904+00	1	dashboard	1	\N	\N	\N	{"description":"Global Content View","name":"Global Content View","dashcards":[{"name":"Global Content Views","description":null,"id":1,"card_id":1}]}
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
18	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.884864	17	EXECUTED	8:62a0483dde183cfd18dd0a86e9354288	createTable tableName=data_migrations; createIndex indexName=idx_data_migrations_id, tableName=data_migrations		\N	3.6.3	\N	\N	4326322455
32	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.090521	31	EXECUTED	8:40830260b92cedad8da273afd5eca678	createTable tableName=label; createIndex indexName=idx_label_slug, tableName=label; createTable tableName=card_label; addUniqueConstraint constraintName=unique_card_label_card_id_label_id, tableName=card_label; createIndex indexName=idx_card_label...		\N	3.6.3	\N	\N	4326322455
11	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.813128	10	EXECUTED	8:ca6561cab1eedbcf4dcb6d6e22cd46c6	sql		\N	3.6.3	\N	\N	4326322455
32	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:03.119819	32	EXECUTED	8:483c6c6c8e0a8d056f7b9112d0b0125c	createTable tableName=raw_table; createIndex indexName=idx_rawtable_database_id, tableName=raw_table; addUniqueConstraint constraintName=uniq_raw_table_db_schema_name, tableName=raw_table; createTable tableName=raw_column; createIndex indexName=id...		\N	3.6.3	\N	\N	4326322455
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
19	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.890519	18	EXECUTED	8:269b129dbfc39a6f9e0d3bc61c3c3b70	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	4326322455
137	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.863596	128	MARK_RAN	8:da754ac6e51313a32de6f6389b29e1ca	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
139	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.867039	130	MARK_RAN	8:fdad4ec86aefb0cdf850b1929b618508	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
140	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.869618	131	MARK_RAN	8:a0cfe6468160bba8c9d602da736c41fb	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
141	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.871753	132	MARK_RAN	8:b6b7faa02cba069e1ed13e365f59cb6b	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
142	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.87365	133	MARK_RAN	8:0c291eb50cc0f1fef3d55cfe6b62bedb	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
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
1	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.750686	1	EXECUTED	8:7182ca8e82947c24fa827d31f78b19aa	createTable tableName=core_organization; createTable tableName=core_user; createTable tableName=core_userorgperm; addUniqueConstraint constraintName=idx_unique_user_id_organization_id, tableName=core_userorgperm; createIndex indexName=idx_userorgp...		\N	3.6.3	\N	\N	4326322455
5	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.775831	4	EXECUTED	8:4f8653d16f4b102b3dff647277b6b988	addColumn tableName=core_organization		\N	3.6.3	\N	\N	4326322455
6	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.783415	5	EXECUTED	8:2d2f5d1756ecb81da7c09ccfb9b1565a	dropNotNullConstraint columnName=organization_id, tableName=metabase_database; dropForeignKeyConstraint baseTableName=metabase_database, constraintName=fk_database_ref_organization_id; dropNotNullConstraint columnName=organization_id, tableName=re...		\N	3.6.3	\N	\N	4326322455
7	cammsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.788931	6	EXECUTED	8:c57c69fd78d804beb77d261066521f7f	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
8	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:02.793142	7	EXECUTED	8:960ec59bbcb4c9f3fa8362eca9af4075	addColumn tableName=metabase_table; addColumn tableName=metabase_field		\N	3.6.3	\N	\N	4326322455
9	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:02.797714	8	EXECUTED	8:d560283a190e3c60802eb04f5532a49d	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	4326322455
10	cammsaul	migrations/000_migrations.yaml	2022-09-28 07:52:02.81005	9	EXECUTED	8:9f03a236be31f54e8e5c894fe5fc7f00	createTable tableName=revision; createIndex indexName=idx_revision_model_model_id, tableName=revision		\N	3.6.3	\N	\N	4326322455
12	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.818642	11	EXECUTED	8:bedbea570e5dfc694b4cf5a8f6a4f445	addColumn tableName=report_card		\N	3.6.3	\N	\N	4326322455
13	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.839282	12	EXECUTED	8:c2c65930bad8d3e9bab3bb6ae562fe0c	createTable tableName=activity; createIndex indexName=idx_activity_timestamp, tableName=activity; createIndex indexName=idx_activity_user_id, tableName=activity; createIndex indexName=idx_activity_custom_id, tableName=activity		\N	3.6.3	\N	\N	4326322455
14	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.856557	13	EXECUTED	8:320d2ca8ead3f31309674b2b7f54f395	createTable tableName=view_log; createIndex indexName=idx_view_log_user_id, tableName=view_log; createIndex indexName=idx_view_log_timestamp, tableName=view_log		\N	3.6.3	\N	\N	4326322455
15	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.861324	14	EXECUTED	8:505b91530103673a9be3382cd2db1070	addColumn tableName=revision		\N	3.6.3	\N	\N	4326322455
16	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.864541	15	EXECUTED	8:ecc7f02641a589e6d35f88587ac6e02b	dropNotNullConstraint columnName=last_login, tableName=core_user		\N	3.6.3	\N	\N	4326322455
17	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.869785	16	EXECUTED	8:051c23cd15359364b9895c1569c319e7	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	4326322455
118	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.82333	109	MARK_RAN	8:17f4410e30a0c7e84a36517ebf4dab64	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
119	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.825991	110	MARK_RAN	8:195cf171ac1d5531e455baf44d9d6561	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
120	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.828913	111	MARK_RAN	8:61f53fac337020aec71868656a719bba	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
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
2	agilliland	migrations/000_migrations.yaml	2022-09-28 07:52:02.763132	2	EXECUTED	8:bdcf1238e2ccb4fbe66d7f9e1d9b9529	createTable tableName=core_session		\N	3.6.3	\N	\N	4326322455
34	tlrobinson	migrations/000_migrations.yaml	2022-09-28 07:52:03.124656	33	EXECUTED	8:52b082600b05bbbc46bfe837d1f37a82	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	4326322455
59	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.444847	58	EXECUTED	8:5b6ce52371e0e9eee88e6d766225a94b	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	4326322455
143	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.875489	134	MARK_RAN	8:3d9a5cb41f77a33e834d0562fdddeab6	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
144	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.877295	135	MARK_RAN	8:1d5b7f79f97906105e90d330a17c4062	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
145	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.878782	136	MARK_RAN	8:b162dd48ef850ab4300e2d714eac504e	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
146	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.880293	137	MARK_RAN	8:8c0c1861582d15fe7859358f5d553c91	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
147	camsaul	migrations/000_migrations.yaml	2022-09-28 07:52:03.88195	138	MARK_RAN	8:5ccf590332ea0744414e40a990a43275	sql	Added 0.34.2	\N	3.6.3	\N	\N	4326322455
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
2	2022-09-28 01:19:53.650399+00	2022-09-28 01:19:53.834596+00	Postgresql	\N	{"host":"host.docker.internal","port":5432,"dbname":"sample","user":"postgres","password":"Alch3mist","ssl":false,"tunnel-port":22}	postgres	f	t	\N	\N	0 50 * * * ? *	0 50 0 * * ? *	Asia/Jakarta	f	\N	t
1	2022-09-28 00:52:04.574583+00	2022-09-28 13:56:13.727783+00	Sample Dataset	\N	{"db":"zip:/app/metabase.jar!/sample-dataset.db;USER=GUEST;PASSWORD=guest"}	h2	t	t	\N	\N	0 50 * * * ? *	0 50 0 * * ? *	Asia/Jakarta	f	\N	t
\.


--
-- Data for Name: metabase_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_field (id, created_at, updated_at, name, base_type, special_type, active, description, preview_display, "position", table_id, parent_id, display_name, visibility_type, fk_target_field_id, last_analyzed, points_of_interest, caveats, fingerprint, fingerprint_version, database_type, has_field_values, settings) FROM stdin;
34	2022-09-28 00:52:05.404554+00	2022-09-28 00:52:09.863039+00	REVIEWER	type/Text	\N	t	The user who left the review	t	0	4	\N	Reviewer	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1076,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":9.972122302158274}}}	4	VARCHAR	\N	\N
121	2022-09-28 13:50:00.312621+00	2022-09-28 13:50:01.275166+00	created_by	type/Text	type/Author	t	\N	t	0	15	\N	Created By	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
114	2022-09-28 13:50:00.264426+00	2022-09-28 13:50:01.252699+00	title	type/Text	type/Title	t	\N	t	0	15	\N	Title	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":14.0}}}	4	varchar	auto-list	\N
3	2022-09-28 00:52:05.145843+00	2022-09-28 00:52:07.684949+00	PRODUCT_ID	type/Integer	type/FK	t	The product ID. This is an internal identifier for the product, NOT the SKU.	t	0	2	\N	Product ID	normal	26	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0}}	4	INTEGER	\N	\N
4	2022-09-28 00:52:05.147349+00	2022-09-28 00:52:05.147349+00	ID	type/BigInteger	type/PK	t	This is a unique ID for the product. It is also called the ???Invoice number??? or ???Confirmation number??? in customer facing emails and screens.	t	0	2	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
13	2022-09-28 00:52:05.26769+00	2022-09-28 00:52:05.26769+00	ID	type/BigInteger	type/PK	t	A unique identifier given to each user.	t	0	3	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
26	2022-09-28 00:52:05.369474+00	2022-09-28 00:52:05.369474+00	ID	type/BigInteger	type/PK	t	The numerical product number. Only used internally. All external communication should use the title or EAN.	t	0	1	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
32	2022-09-28 00:52:05.4015+00	2022-09-28 00:52:05.4015+00	ID	type/BigInteger	type/PK	t	A unique internal identifier for the review. Should not be used externally.	t	0	4	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N
110	2022-09-28 13:50:00.254252+00	2022-09-28 13:50:00.987133+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	15	\N	Air Byte Emitted At	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T12:35:13.538Z","latest":"2022-09-28T12:35:13.538Z"}}}	4	timestamptz	\N	\N
115	2022-09-28 13:50:00.266973+00	2022-09-28 13:50:01.257066+00	created_at	type/DateTimeWithLocalTZ	type/CreationTimestamp	t	\N	t	0	15	\N	Created At	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-25T12:42:04Z","latest":"2022-09-25T12:47:45Z"}}}	4	timestamptz	\N	\N
122	2022-09-28 13:50:00.370861+00	2022-09-28 13:50:01.294316+00	id	type/Integer	type/PK	t	\N	t	0	16	\N	ID	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	\N	4	int4	\N	\N
39	2022-09-28 01:19:54.070689+00	2022-09-28 01:19:55.395883+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	13	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
116	2022-09-28 13:50:00.269226+00	2022-09-28 13:50:01.262076+00	_airbyte_ab_id	type/Text	type/Category	t	\N	t	0	15	\N	Air Byte Ab ID	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	varchar	auto-list	\N
25	2022-09-28 00:52:05.368084+00	2022-09-28 00:52:09.53927+00	PRICE	type/Float	\N	t	The list price of the product. Note that this is not always the price the product sold for due to discounts, promotions, etc.	t	0	1	\N	Price	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":170,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"max":98.81933684368194,"avg":55.74639966792074,"sd":21.711481557852057,"q1":37.25154462926434,"q3":75.45898071609447}}}	4	DOUBLE	\N	\N
117	2022-09-28 13:50:00.304215+00	2022-09-28 13:50:01.26629+00	updated_by	type/Text	type/Category	t	\N	t	0	15	\N	Updated By	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.6666666666666667},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":12.0}}}	4	varchar	auto-list	\N
123	2022-09-28 13:50:00.414859+00	2022-09-28 13:50:01.328585+00	id	type/Integer	type/PK	t	\N	t	0	17	\N	ID	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	\N	4	int4	\N	\N
19	2022-09-28 00:52:05.319118+00	2022-09-28 00:52:09.447439+00	ZIP	type/Text	type/ZipCode	t	The postal code of the account???s billing address	t	0	3	\N	Zip	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2234,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":5.0}}}	4	CHAR	\N	\N
118	2022-09-28 13:50:00.306632+00	2022-09-28 13:50:01.00752+00	updated_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	15	\N	Updated At	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.6666666666666667},"type":{"type/DateTime":{"earliest":"2022-09-25T12:44:25Z","latest":"2022-09-25T12:44:25Z"}}}	4	timestamptz	\N	\N
119	2022-09-28 13:50:00.308652+00	2022-09-28 13:50:01.009702+00	_airbyte_normalized_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	15	\N	Air Byte Normalized At	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T12:35:22.373268Z","latest":"2022-09-28T12:35:22.373268Z"}}}	4	timestamptz	\N	\N
109	2022-09-28 13:50:00.250274+00	2022-09-28 13:50:01.162634+00	url	type/Text	type/URL	t	\N	t	0	15	\N	URL	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":1.0,"percent-email":0.0,"average-length":65.33333333333333}}}	4	varchar	auto-list	\N
5	2022-09-28 00:52:05.148977+00	2022-09-28 00:52:07.689784+00	SUBTOTAL	type/Float	\N	t	The raw, pre-tax cost of the order. Note that this might be different in the future from the product price due to promotions, credits, etc.	t	0	2	\N	Subtotal	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":340,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"max":148.22900526552291,"avg":77.01295465356547,"sd":32.53705013056317,"q1":49.74894519060184,"q3":105.42965746993103}}}	4	DOUBLE	\N	\N
111	2022-09-28 13:50:00.25712+00	2022-09-28 13:50:01.166905+00	global_view_count	type/BigInteger	type/Quantity	t	\N	t	0	15	\N	Global View Count	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Number":{"min":1.0,"max":3.0,"avg":1.6666666666666667,"sd":1.1547005383792517,"q1":1.0,"q3":2.550510257216822}}}	4	int8	auto-list	\N
21	2022-09-28 00:52:05.324012+00	2022-09-28 00:52:09.432295+00	PASSWORD	type/Text	\N	t	This is the salted password of the user. It should not be visible	t	0	3	\N	Password	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":36.0}}}	4	VARCHAR	\N	\N
8	2022-09-28 00:52:05.15371+00	2022-09-28 00:52:07.692779+00	TAX	type/Float	\N	t	This is the amount of local and federal taxes that are collected on the purchase. Note that other governmental fees on some products are not included here, but instead are accounted for in the subtotal.	t	0	2	\N	Tax	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":797,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":11.12,"avg":3.8722100000000004,"sd":2.3206651358900316,"q1":2.273340386603857,"q3":5.337275338216307}}}	4	DOUBLE	\N	\N
16	2022-09-28 00:52:05.297061+00	2022-09-28 00:52:09.937643+00	SOURCE	type/Text	type/Source	t	The channel through which we acquired this user. Valid values include: Affiliate, Facebook, Google, Organic and Twitter	t	0	3	\N	Source	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":7.4084}}}	4	VARCHAR	auto-list	\N
112	2022-09-28 13:50:00.259547+00	2022-09-28 13:50:01.170949+00	_airbyte_contents_hashid	type/Text	type/Category	t	\N	t	0	15	\N	Air Byte Contents Hash ID	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":32.0}}}	4	text	auto-list	\N
33	2022-09-28 00:52:05.403064+00	2022-09-28 00:52:09.851841+00	BODY	type/Text	type/Description	t	The review the user left. Limited to 2000 characters.	t	0	4	\N	Body	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":180.37769784172662}}}	4	CLOB	\N	\N
10	2022-09-28 00:52:05.2561+00	2022-09-28 00:52:09.917863+00	LATITUDE	type/Float	type/Latitude	t	This is the latitude of the user on sign-up. It might be updated in the future to the last seen location.	t	0	3	\N	Latitude	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":25.775827,"max":70.6355001,"avg":39.87934670484002,"sd":6.390832341883712,"q1":35.302705923023126,"q3":43.773802584662}}}	4	DOUBLE	\N	\N
113	2022-09-28 13:50:00.262074+00	2022-09-28 13:50:01.247669+00	description	type/Text	type/Description	t	\N	t	0	15	\N	Description	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":23.333333333333332}}}	4	varchar	auto-list	\N
120	2022-09-28 13:50:00.310381+00	2022-09-28 13:50:01.271744+00	id	type/Text	type/PK	t	\N	t	0	15	\N	ID	normal	\N	2022-09-28 13:50:01.372615+00	\N	\N	\N	4	varchar	\N	\N
1	2022-09-28 00:52:05.141388+00	2022-09-28 00:52:07.696713+00	USER_ID	type/Integer	type/FK	t	The id of the user who made this order. Note that in some cases where an order was created on behalf of a customer who phoned the order in, this might be the employee who handled the request.	t	0	2	\N	User ID	normal	13	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":929,"nil%":0.0}}	4	INTEGER	\N	\N
84	2022-09-28 01:19:54.506572+00	2022-09-28 01:19:55.808791+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	7	\N	Air Byte Emitted At	normal	\N	2022-09-28 01:19:56.151906+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2022-09-28T01:18:27.63Z","latest":"2022-09-28T01:18:27.63Z"}}}	4	timestamptz	\N	\N
17	2022-09-28 00:52:05.307291+00	2022-09-28 00:52:09.914239+00	EMAIL	type/Text	type/Email	t	The contact email for the account.	t	0	3	\N	Email	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":1.0,"average-length":24.1824}}}	4	VARCHAR	\N	\N
12	2022-09-28 00:52:05.263966+00	2022-09-28 00:52:09.932128+00	NAME	type/Text	type/Name	t	The name of the user who owns an account	t	0	3	\N	Name	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2499,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":13.532}}}	4	VARCHAR	\N	\N
22	2022-09-28 00:52:05.325737+00	2022-09-28 00:52:09.905875+00	CITY	type/Text	type/City	t	The city of the account???s billing address	t	0	3	\N	City	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1966,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":8.284}}}	4	VARCHAR	\N	\N
15	2022-09-28 00:52:05.274838+00	2022-09-28 00:52:09.928189+00	LONGITUDE	type/Float	type/Longitude	t	This is the longitude of the user on sign-up. It might be updated in the future to the last seen location.	t	0	3	\N	Longitude	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":-166.5425726,"max":-67.96735199999999,"avg":-95.18741780363999,"sd":15.399698968175663,"q1":-101.58350792373135,"q3":-84.65289348288829}}}	4	DOUBLE	\N	\N
20	2022-09-28 00:52:05.321934+00	2022-09-28 00:52:09.943441+00	STATE	type/Text	type/State	t	The state or province of the account???s billing address	t	0	3	\N	State	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":49,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":2.0}}}	4	CHAR	auto-list	\N
11	2022-09-28 00:52:05.261253+00	2022-09-28 00:52:09.418666+00	BIRTH_DATE	type/Date	\N	t	The date of birth of the user	t	0	3	\N	Birth Date	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2308,"nil%":0.0},"type":{"type/DateTime":{"earliest":"1958-04-26","latest":"2000-04-03"}}}	4	DATE	\N	\N
18	2022-09-28 00:52:05.310033+00	2022-09-28 00:52:09.909663+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the user record was created. Also referred to as the user???s "join date"	t	0	3	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-19T21:35:18.752","latest":"2019-04-19T14:06:27.3"}}}	4	TIMESTAMP	\N	\N
28	2022-09-28 00:52:05.375677+00	2022-09-28 00:52:09.954077+00	CATEGORY	type/Text	type/Category	t	The type of product, valid values include: Doohicky, Gadget, Gizmo and Widget	t	0	1	\N	Category	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":6.375}}}	4	VARCHAR	auto-list	\N
29	2022-09-28 00:52:05.377297+00	2022-09-28 00:52:09.957919+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the product was added to our catalog.	t	0	1	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-26T19:29:55.147","latest":"2019-04-15T13:34:19.931"}}}	4	TIMESTAMP	\N	\N
23	2022-09-28 00:52:05.364374+00	2022-09-28 00:52:09.537315+00	EAN	type/Text	\N	t	The international article number. A 13 digit number uniquely identifying the product.	t	0	1	\N	Ean	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":13.0}}}	4	CHAR	\N	\N
24	2022-09-28 00:52:05.366399+00	2022-09-28 00:52:09.961841+00	RATING	type/Float	type/Score	t	The average rating users have given the product. This ranges from 1 - 5	t	0	1	\N	Rating	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":23,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":5.0,"avg":3.4715,"sd":1.3605488657451452,"q1":3.5120465053408525,"q3":4.216124969497314}}}	4	DOUBLE	\N	\N
27	2022-09-28 00:52:05.373835+00	2022-09-28 00:52:09.965098+00	TITLE	type/Text	type/Title	t	The name of the product as it should be displayed to customers.	t	0	1	\N	Title	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":199,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":21.495}}}	4	VARCHAR	\N	\N
30	2022-09-28 00:52:05.379057+00	2022-09-28 00:52:09.968702+00	VENDOR	type/Text	type/Company	t	The source of the product.	t	0	1	\N	Vendor	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":20.6}}}	4	VARCHAR	\N	\N
35	2022-09-28 00:52:05.406008+00	2022-09-28 00:52:09.975221+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The day and time a review was written by a user.	t	0	4	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-06-03T00:37:05.818","latest":"2020-04-19T14:15:25.677"}}}	4	TIMESTAMP	\N	\N
31	2022-09-28 00:52:05.399625+00	2022-09-28 00:52:09.85763+00	PRODUCT_ID	type/Integer	type/FK	t	The product the review was for	t	0	4	\N	Product ID	normal	26	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":176,"nil%":0.0}}	4	INTEGER	\N	\N
9	2022-09-28 00:52:05.155145+00	2022-09-28 00:52:07.69485+00	TOTAL	type/Float	\N	t	The total billed amount.	t	0	2	\N	Total	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":10000,"nil%":0.0},"type":{"type/Number":{"min":12.061602936923117,"max":238.32732001721533,"avg":82.96014815230805,"sd":38.35967664847571,"q1":52.006147617878135,"q3":109.55803018499738}}}	4	DOUBLE	\N	\N
6	2022-09-28 00:52:05.15045+00	2022-09-28 00:52:09.894247+00	QUANTITY	type/Integer	type/Quantity	t	Number of products bought.	t	0	2	\N	Quantity	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":62,"nil%":0.0},"type":{"type/Number":{"min":0.0,"max":100.0,"avg":3.7015,"sd":4.214258386403798,"q1":1.755882607764982,"q3":4.882654507928044}}}	4	INTEGER	auto-list	\N
2	2022-09-28 00:52:05.144093+00	2022-09-28 00:52:09.887833+00	DISCOUNT	type/Float	type/Discount	t	Discount amount.	t	0	2	\N	Discount	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":701,"nil%":0.898},"type":{"type/Number":{"min":0.17088996672584322,"max":61.69684269960571,"avg":5.161255547580326,"sd":3.053663125001991,"q1":2.9786226681458743,"q3":7.338187788658235}}}	4	DOUBLE	\N	\N
7	2022-09-28 00:52:05.151886+00	2022-09-28 00:52:09.884039+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date and time an order was submitted.	t	0	2	\N	Created At	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":9998,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-30T18:56:13.352","latest":"2020-04-19T14:07:15.657"}}}	4	TIMESTAMP	\N	\N
14	2022-09-28 00:52:05.271187+00	2022-09-28 00:52:09.416005+00	ADDRESS	type/Text	\N	t	The street address of the account???s billing address	t	0	3	\N	Address	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":2490,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":20.85}}}	4	VARCHAR	\N	\N
38	2022-09-28 01:19:54.068081+00	2022-09-28 01:19:54.068081+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	13	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
41	2022-09-28 01:19:54.130849+00	2022-09-28 01:19:54.130849+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	12	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
43	2022-09-28 01:19:54.164816+00	2022-09-28 01:19:54.164816+00	_airbyte_data	type/Text	\N	t	\N	t	0	8	\N	Air Byte Data	normal	\N	\N	\N	\N	\N	0	jsonb	\N	\N
44	2022-09-28 01:19:54.166877+00	2022-09-28 01:19:54.166877+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	8	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
45	2022-09-28 01:19:54.168821+00	2022-09-28 01:19:54.168821+00	_airbyte_emitted_at	type/DateTimeWithLocalTZ	\N	t	\N	t	0	8	\N	Air Byte Emitted At	normal	\N	\N	\N	\N	\N	0	timestamptz	\N	\N
47	2022-09-28 01:19:54.210181+00	2022-09-28 01:19:54.210181+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	11	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
50	2022-09-28 01:19:54.244782+00	2022-09-28 01:19:54.244782+00	_airbyte_ab_id	type/Text	type/PK	t	\N	t	0	10	\N	Air Byte Ab ID	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N
36	2022-09-28 00:52:05.407502+00	2022-09-28 00:52:09.979102+00	RATING	type/Integer	type/Score	t	The rating (on a scale of 1-5) the user left.	t	0	4	\N	Rating	normal	\N	2022-09-28 00:52:10.035523+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Number":{"min":1.0,"max":5.0,"avg":3.987410071942446,"sd":1.0443899855660577,"q1":3.54744353181696,"q3":4.764807071650455}}}	4	SMALLINT	auto-list	\N
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
2	2022-09-28 00:52:05.059234+00	2022-09-28 15:50:01.077989+00	ORDERS	\N	This is a confirmed order for a product from a user.	\N	entity/TransactionTable	t	1	Orders	\N	PUBLIC	\N	\N	f	Iqz4vNbm7vh80Uo9pWdesA==
3	2022-09-28 00:52:05.064943+00	2022-09-28 15:50:01.124717+00	PEOPLE	\N	This is a user account. Note that employees and customer support staff will have accounts.	\N	entity/UserTable	t	1	People	\N	PUBLIC	\N	\N	f	CXKI5VefRbNYgZ8IStmaNw==
1	2022-09-28 00:52:05.049042+00	2022-09-28 15:50:01.17397+00	PRODUCTS	\N	This is our product catalog. It includes all products ever sold by the Sample Company.	\N	entity/ProductTable	t	1	Products	\N	PUBLIC	\N	\N	f	aqXlpsb4FjyCH5o8qP4a2A==
4	2022-09-28 00:52:05.071252+00	2022-09-28 15:50:01.295654+00	REVIEWS	\N	These are reviews our customers have left on products. Note that these are not tied to orders so it is possible people have reviewed products they did not purchase from us.	\N	entity/GenericTable	t	1	Reviews	\N	PUBLIC	\N	\N	f	wIcr7cLnXrbpAUfOXgcmeQ==
15	2022-09-28 13:50:00.150642+00	2022-09-28 13:50:01.343186+00	global_content_views	\N	\N	\N	entity/GenericTable	t	2	Global Content Views	\N	sample	\N	\N	f	3G6OnQUKl7zgA7RLO+GBKw==
16	2022-09-28 13:50:00.160221+00	2022-09-28 13:50:01.347205+00	my_second_dbt_model	\N	\N	\N	entity/GenericTable	t	2	My Second Dbt Model	\N	sample	\N	\N	f	+OEEKG/qkc3aQxZDCQTfaw==
17	2022-09-28 13:50:00.166726+00	2022-09-28 13:50:01.35092+00	my_first_dbt_model	\N	\N	\N	entity/GenericTable	t	2	My First Dbt Model	\N	sample	\N	\N	f	+OEEKG/qkc3aQxZDCQTfaw==
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
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	0 50 0 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	0 50 0 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	0 15 6,18 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	0 15 7 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	0 0 12 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	0 0 12 * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	0 0 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	0 0 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	0 50 * * * ? *	Asia/Jakarta
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	0 50 * * * ? *	Asia/Jakarta
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
MetabaseScheduler	metabase1664373373296	1664380769359	7500
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
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 2	1664387400000	-1	5	WAITING	CRON	1664373373000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 1	1664387400000	-1	5	WAITING	CRON	1664373373000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	metabase.task.upgrade-checks.job	DEFAULT	\N	1664406900000	-1	5	WAITING	CRON	1664373373000	0	\N	0	\\x
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	metabase.task.anonymous-stats.job	DEFAULT	\N	1664410500000	-1	5	WAITING	CRON	1664373373000	0	\N	0	\\x
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	metabase.task.abandonment-emails.job	DEFAULT	\N	1664427600000	-1	5	WAITING	CRON	1664373373000	0	\N	0	\\x
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	metabase.task.follow-up-emails.job	DEFAULT	\N	1664427600000	-1	5	WAITING	CRON	1664373373000	0	\N	0	\\x
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	metabase.task.send-pulses.job	DEFAULT	\N	1664380800000	1664377200000	5	WAITING	CRON	1664373373000	0	\N	1	\\x
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	metabase.task.task-history-cleanup.job	DEFAULT	\N	1664380800000	1664377200000	5	WAITING	CRON	1664373373000	0	\N	0	\\x
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 2	1664383800000	1664380200000	5	WAITING	CRON	1664373373000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 1	1664383800000	1664380200000	5	WAITING	CRON	1664373373000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
\.


--
-- Data for Name: query; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query (query_hash, average_execution_time, query) FROM stdin;
\\xd80498e570017b85c608715852d0f7d238eb1740db93f96f444d44a9573d5eb7	307	{"type":"query","database":2,"query":{"source-table":7,"filter":["and",["time-interval",["datetime-field",["field-id",87],"minute"],-30,"day"]],"aggregation":[["count"]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x45cd8c64b89e21dde13b5ece43c9a731eb037013c1484f9803761ee29aec0740	255	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",86]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x0ff8d16437b0ed23ad129061c4726939099b5371f9be57bf6300df1222a93d7f	338	{"type":"query","database":2,"query":{"source-table":7,"aggregation":[["count"]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x874d4b00235469f4feef81229113a6ea7ef4158cdfc74552d9208cb951893f76	289	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",85]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xe6a084e38e9cf42aecdcf136467ffd05b8f1c64c58f73a709716386ab43a542b	353	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["datetime-field",["field-id",87],"minute"]],"aggregation":[["count"]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xf85df25c62a49e35de2cf76dd00ae8f331c6d4ee4a8253727c494df51f4da1bd	147	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",95]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x5969690c8239e40c05e174d47c81300daeef6646f41ec7985f230ea4be24dee8	143	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",89]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xfff4e5f29f089943073d4c46f6dd9208947545a2286819ed399781f79a2c1f73	219	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",83]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xc5e38acc38298aa29cf648feeb259c9782b6bbfb054ced5ea633bf00df9a8c1c	188	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",88]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x0be21a80f56967fa211cd0ba12157a41f099a672f959d158a969d2bcaf49b704	132	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",81]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xb25abf09dcefc6a30c50e31525a53c983f82bc1114986b21e4b59b941a592373	107	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",80]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x889c183655051c9ecb5c0f8854acb9b39ff7e9d6d1f9fb619766b4bd31dabd0a	34	{"type":"query","database":2,"query":{"source-table":7,"breakout":[["field-id",94]],"aggregation":[["count"]],"order-by":[["desc",["aggregation",0]]]},"parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x54b160e979695e1d1213a5c53476788ccc8a1ef6b05fd7389aebb9f278484dd0	173	{"database":2,"query":{"source-table":15},"type":"query","parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\xadfdf6e61ae48d47e2c9c2106cda68b885d5a41a9d2976ac97a4d86fb51ed240	29	{"database":2,"query":{"source-table":15,"fields":[["field-id",113],["field-id",111],["field-id",120],["field-id",114],["field-id",109]]},"type":"query","parameters":[],"async?":true,"middleware":{"add-default-userland-constraints?":true,"userland-query?":true},"constraints":{"max-results":10000,"max-results-bare-rows":2000}}
\\x39c61c93f8eb9367b520b2c99ceb781bdd132fb035806c503c662894ba6ff379	53	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"query","middleware":{"userland-query?":true},"database":2,"query":{"source-table":15,"fields":[["field-id",120],["field-id",114],["field-id",113],["field-id",109],["field-id",111]]},"parameters":[],"async?":true,"cache-ttl":null}
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
1	\\xd80498e570017b85c608715852d0f7d238eb1740db93f96f444d44a9573d5eb7	2022-09-28 17:52:17.188747	307	1	f	ad-hoc	\N	1	\N	\N	\N	2
2	\\x45cd8c64b89e21dde13b5ece43c9a731eb037013c1484f9803761ee29aec0740	2022-09-28 17:52:17.193188	255	1	f	ad-hoc	\N	1	\N	\N	\N	2
3	\\x0ff8d16437b0ed23ad129061c4726939099b5371f9be57bf6300df1222a93d7f	2022-09-28 17:52:17.192576	338	1	f	ad-hoc	\N	1	\N	\N	\N	2
4	\\x874d4b00235469f4feef81229113a6ea7ef4158cdfc74552d9208cb951893f76	2022-09-28 17:52:17.217367	289	1	f	ad-hoc	\N	1	\N	\N	\N	2
5	\\xe6a084e38e9cf42aecdcf136467ffd05b8f1c64c58f73a709716386ab43a542b	2022-09-28 17:52:17.242059	353	1	f	ad-hoc	\N	1	\N	\N	\N	2
6	\\xe6a084e38e9cf42aecdcf136467ffd05b8f1c64c58f73a709716386ab43a542b	2022-09-28 17:52:17.303079	357	1	f	ad-hoc	\N	1	\N	\N	\N	2
7	\\xf85df25c62a49e35de2cf76dd00ae8f331c6d4ee4a8253727c494df51f4da1bd	2022-09-28 17:52:17.501639	147	1	f	ad-hoc	\N	1	\N	\N	\N	2
8	\\x5969690c8239e40c05e174d47c81300daeef6646f41ec7985f230ea4be24dee8	2022-09-28 17:52:17.504824	143	1	f	ad-hoc	\N	1	\N	\N	\N	2
9	\\xfff4e5f29f089943073d4c46f6dd9208947545a2286819ed399781f79a2c1f73	2022-09-28 17:52:17.511798	219	1	f	ad-hoc	\N	1	\N	\N	\N	2
10	\\xc5e38acc38298aa29cf648feeb259c9782b6bbfb054ced5ea633bf00df9a8c1c	2022-09-28 17:52:17.544205	188	1	f	ad-hoc	\N	1	\N	\N	\N	2
11	\\x0be21a80f56967fa211cd0ba12157a41f099a672f959d158a969d2bcaf49b704	2022-09-28 17:52:17.577638	132	1	f	ad-hoc	\N	1	\N	\N	\N	2
12	\\xb25abf09dcefc6a30c50e31525a53c983f82bc1114986b21e4b59b941a592373	2022-09-28 17:52:17.590563	107	1	f	ad-hoc	\N	1	\N	\N	\N	2
13	\\x889c183655051c9ecb5c0f8854acb9b39ff7e9d6d1f9fb619766b4bd31dabd0a	2022-09-28 17:52:17.607686	34	1	f	ad-hoc	\N	1	\N	\N	\N	2
14	\\x54b160e979695e1d1213a5c53476788ccc8a1ef6b05fd7389aebb9f278484dd0	2022-09-28 22:53:58.290486	173	3	f	ad-hoc	\N	1	\N	\N	\N	2
15	\\xadfdf6e61ae48d47e2c9c2106cda68b885d5a41a9d2976ac97a4d86fb51ed240	2022-09-28 22:55:01.080916	29	3	f	ad-hoc	\N	1	\N	\N	\N	2
16	\\x39c61c93f8eb9367b520b2c99ceb781bdd132fb035806c503c662894ba6ff379	2022-09-28 22:57:48.734698	53	3	f	question	\N	1	1	\N	\N	2
\.


--
-- Data for Name: report_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_card (id, created_at, updated_at, name, description, display, dataset_query, visualization_settings, creator_id, database_id, table_id, query_type, archived, collection_id, public_uuid, made_public_by_id, enable_embedding, embedding_params, cache_ttl, result_metadata, read_permissions, collection_position) FROM stdin;
1	2022-09-28 15:57:16.194868+00	2022-09-28 15:57:48.715821+00	Global Content Views	\N	row	{"database":2,"query":{"source-table":15,"fields":[["field-id",120],["field-id",114],["field-id",113],["field-id",109],["field-id",111]]},"type":"query"}	{"table.columns":[{"name":"id","fieldRef":["field-id",120],"enabled":true},{"name":"title","fieldRef":["field-id",114],"enabled":true},{"name":"description","fieldRef":["field-id",113],"enabled":true},{"name":"url","fieldRef":["field-id",109],"enabled":true},{"name":"global_view_count","fieldRef":["field-id",111],"enabled":true}],"graph.dimensions":["title"],"graph.metrics":["global_view_count"]}	1	2	15	query	f	\N	\N	\N	f	\N	\N	[{"name":"id","display_name":"ID","base_type":"type/Text","special_type":"type/PK","fingerprint":null},{"name":"title","display_name":"Title","base_type":"type/Text","special_type":"type/Title","fingerprint":{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":14.0}}}},{"name":"description","display_name":"Description","base_type":"type/Text","special_type":"type/Description","fingerprint":{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"average-length":23.333333333333332}}}},{"name":"url","display_name":"URL","base_type":"type/Text","special_type":"type/URL","fingerprint":{"global":{"distinct-count":3,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":1.0,"percent-email":0.0,"average-length":65.33333333333333}}}},{"name":"global_view_count","display_name":"Global View Count","base_type":"type/BigInteger","special_type":"type/Quantity","fingerprint":{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Number":{"min":1.0,"max":3.0,"avg":1.6666666666666667,"sd":1.1547005383792517,"q1":1.0,"q3":2.550510257216822}}}}]	\N	\N
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
1	2022-09-28 15:57:48.38403+00	2022-09-28 15:57:55.238935+00	Global Content View	Global Content View	1	[]	\N	\N	f	\N	\N	f	\N	f	\N	\N	\N
\.


--
-- Data for Name: report_dashboardcard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_dashboardcard (id, created_at, updated_at, "sizeX", "sizeY", "row", col, card_id, dashboard_id, parameter_mappings, visualization_settings) FROM stdin;
1	2022-09-28 15:57:55.112548+00	2022-09-28 15:57:55.187228+00	4	4	0	0	1	1	[]	{}
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision (id, model, model_id, user_id, "timestamp", object, is_reversion, is_creation, message) FROM stdin;
1	Card	1	1	2022-09-28 15:57:16.315683+00	{"description":null,"archived":false,"collection_position":null,"table_id":15,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"query","name":"Global Content Views","read_permissions":null,"creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"database":2,"query":{"source-table":15,"fields":[["field-id",120],["field-id",114],["field-id",113],["field-id",109],["field-id",111]]},"type":"query"},"id":1,"display":"row","visualization_settings":{"table.columns":[{"name":"id","fieldRef":["field-id",120],"enabled":true},{"name":"title","fieldRef":["field-id",114],"enabled":true},{"name":"description","fieldRef":["field-id",113],"enabled":true},{"name":"url","fieldRef":["field-id",109],"enabled":true},{"name":"global_view_count","fieldRef":["field-id",111],"enabled":true}],"graph.dimensions":["title"],"graph.metrics":["global_view_count"]},"public_uuid":null}	f	t	\N
2	Dashboard	1	1	2022-09-28 15:57:48.41722+00	{"description":"Global Content View","name":"Global Content View","cards":[]}	f	t	\N
3	Dashboard	1	1	2022-09-28 15:57:55.145496+00	{"description":"Global Content View","name":"Global Content View","cards":[{"sizeX":2,"sizeY":2,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
4	Dashboard	1	1	2022-09-28 15:57:55.210056+00	{"description":"Global Content View","name":"Global Content View","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
5	Dashboard	1	1	2022-09-28 15:57:55.255373+00	{"description":"Global Content View","name":"Global Content View","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
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
site-uuid	9f0bda79-091b-4a62-b04d-c7b53c09730c
version-info	{"latest":{"version":"v0.44.3","released":"2022-09-15","patch":true,"highlights":["SessionStorage can become filled causing the frontend to throw errors until browser restart","Filters incorrectly showing as linked to all fields on combined charts","First created question not in Saved Questions inside Data Selector until page reload","Cannot change email From-name and Reply-to-address when environment variables are used for other settings","Column filters not working on multi-aggregation","Tooltip periods are not displayed nicely on SQL questions","Can't change filters via 'Show filters'","Bubble size not consistent across multiple series","A hidden Database Sync doesn't allow descriptions for tables or fields to be edited","Newly created Model not an option when creating a new question","Dashboard filter does not show Search widget when trying to workaround other filter issues","Chinese weekdays in calendar widget are incorrect","Field filter linked to Boolean column causes an error when refreshing a public question","Slack files channel can be confusing after initial setup"]},"older":[{"version":"v0.44.0","released":"2022-08-04","patch":false,"highlights":["Blank screen if user without permissions to view dashboard card tries to edit the dashboard filter","Bump jetty-server to 9.4.48.v20220622","Click behavior to another dashboard/question makes the browser open the destination on a new window","False warning that `No self-service` means higher access than `Block` permissions","Bookmark icon not updated when question is converted to model and vice-versa","Scalars show short number before showing the full number","Default /api/collection/tree call does not include \\"exclude-archived=true\\"","Archive page does not render all items","Revert buttons shown on dashboard revision history for users without edit permissions","Search returns irrelevant matches for non-native questions","Can't embed cards with filters after v0.44.0-RC1 - Invalid Parameters: \\"missing id\\"","CASE statements don't evaluate to False if using `, False` and nested CASE statements","\\"Custom...\\" model refresh setting does not work on first request","\\"Our analytics\\" appears on \\"Save question\\" collection search header even when user doesn't have access to it","Exports fail on specific date styles","Bubble size is scaling according to y-axis on scatter charts","Error sending emails when reply-to setting contains empty string","Email settings needs to use real password, not obfuscated password","Wrong username/password on Office365 for email settings has misleading error","Bulk Filter Modal v3","Add snowplow tracking for new records on TaskHistory","Missing full-screen button on public dashboards","Primary color is not being used on background colors, so branding is not kept consistent","Full Screen Night Mode Dashboard Has light background when scrolled down","Dark primary color in data visualization makes icons almost disappear.","Primary color in text with dark backgrounds makes text hard to read","Relative Date filters on dashboard does not include the filter on drill-through","Dashboard causes scrollbars to constantly go on/off depending on viewport size","Items in the saved question picker are sorted case-sensitive","Sandboxed group managers can't see other users in the People tab"]},{"version":"v0.43.4.2","released":"2022-07-29","patch":true,"highlights":[]},{"version":"v0.43.4.1","released":"2022-07-28","patch":true,"highlights":[]},{"version":"v0.43.4","released":"2022-06-28","patch":true,"highlights":["Blank screen on questions with certain orphaned visualization settings","Metabase returns \\"No results!\\" when the SSH tunnel is down on a query","Changing account password to a non-complex password misleads the user with a success message even though the process fails","Relative \\"quarter\\" filter doesn't work in SQL queries","New Slack setup not working, because App isn't joining the files channel","Tooltips goes outside of iframe in some cases","\\"Can't pop empty vector\\" when binning JSON fields","Collection name under dashboard title wraps weirdly when viewport is narrow","Incorrect use of types during Postgres JSON unfolding","Cannot filter `time` columns unless using the QB Sidebar","Frontend incorrectly shows empty boolean values as `false`"]},{"version":"v0.43.3","released":"2022-06-13","patch":true,"highlights":["Slack setup doesn't work if channels cache was recently cleared","Custom Expression field is not respecting the modal size","Bump google oauth version","Relative filter with a lower \\"Starting from\\" period is confusing","Cannot print large dashboards (multi page)","Sync of JSON columns fails in schemas where schema names contains system characters","Sync of fields fails, when table name contains uppercase characters","Preview function in Notebook does not respect the columns selected on base source","Viewing Metadata for a Model and cancelling can result in error, and further in blank screen","Do not offer \\"Explore results\\" unless the database supports it","Cannot view Object Detail of non-numeric IDs","Incorrect use of types during Postgres JSON unfolding","Click Behavior not redirecting in some cases","Uploading certificates causes failure in TrustManager/KeyManager because of bad MIME-type","New Slack App does not allow selecting private channels for pulses","Query executions hitting the cache are not recorded","Pulse fails when there is a column type `time`"]},{"version":"v0.43.2","released":"2022-05-31","patch":true,"highlights":["Bump transitive com.google.code.gson/gson","Login page: Whitelabeled logo clips top of page if vertical","Sign in input fields are outside of screen on mobile","Filters are taking 100% viewport width on mobile/tablet in v.43.1","Updating data permissions counts questions as tables","Fix deadlock in pivot table connection management","Size of bubbles not respected on scatter chart","Strings in the time series chrome UI aren't tagged for translation","dont read settings at require time","Unable to edit field name and description in Field page","Custom Expression aggregation in Metrics does not work","CPU spiking every hour since v0.43.0 upgrade","Negative Y axis points not rendered on scatter plot","X-ray charts don't seem to respect whitelabel colors","Users with `block` permissions see ambiguous error message when they open a dashboard","It is possible to change filter column when filter date columns from the table header","We should cut the \\"Navigation bar color\\" option from /admin/settings/whitelabel","Site URL setting reverting to default randomly","Cannot use Click Behavior for filters with multiple options selected","Click Behavior with filter pass-thru causes permission error (even for admins)"]},{"version":"v0.43.1","released":"2022-05-16","patch":true,"highlights":[]},{"version":"v0.43.0","released":"2022-05-02","patch":false,"highlights":["Inconsistent colors in relative datetime filtering in sidebar","Non-admin database manager can delete database using the API","Query Builder data picker can \\"forget\\" about multiple schemas","Data Model > Visibility buttons should \\"signal\\" they are clickable","Date filter in the chart footer shows \\"Previous\\" filter type when \\"All Time\\" is selected","\\"Next\\" relative filter tokens should read \\"from now\\" instead of \\"ago\\"","Can't change a relative month filter's values when using the \\"starting from\\" feature","Date preview is wrong when using the \\"Starting from???\\" action when it pushes back before the current year","`Include this quarter` action is missing the words \\"this quarter\\"","Purple borders in date filter popover should be blue","In the relative date picker, changing the granularity of the Past/Next range picker should change the granularity of the Starting From picker","Let's add the \\"Metabase tips\\" link for installers, too","Errors when hiding/unhiding specific columns in table","moving timelines and default interact poorly","Sidebar stays open after entering a dashboard's fullscreen mode","Exports fail when certain columns are hidden and a field is remapped","Random comma in \\"Display values\\" section of data model settings for a field","Selecting language Indonesian causes error","Can not get the minimum or maximum of some SQL fields","MAX/MIN aggregation on categories incorrectly inferred as numbers","[Data Permissions] Saved questions showing in the list of databases","Textbox on dashboards are difficult move and missing options","Permission graph does not support schemas with slashes","Backend should deserialize dashboard `Starting From`/`Exclude` datetime filters","Datetime shortcut \\"Relative dates...\\" should default to \\"Past\\" filters","Embedding/Public sharing of questions does not show download button in the footer","Dashboard shows scrollbar in fullscreen","Subscriptions button shown on dashboard in fullscreen","Global search input is shorter than the field","Popover menu position floating too far initiator"]},{"version":"v0.42.4","released":"2022-04-07","patch":true,"highlights":[]},{"version":"v0.42.3","released":"2022-03-23","patch":true,"highlights":["Exclude /_internals from production build (#21162)","Upgrade MySQL/MariaDB JDBC driver to version 2.7.5","Comma Separate Numbers filter not working as it previously did","Markdown parsing on backend doesn't support autolinks","Subscription fails, when there's specific characters that causes Markdown failure","Custom Column allows aggregation functions together with algebra, which fails on query","Cannot connect Google Analytics because of deprecated OAuth OOB","Postgres certificate SSL key reference incorrect","Embedding with Locked parameters does not allow numeric values","Models should not be shareable (embedding/public)","BigQuery: Aggregating by a datetime in a saved question fails because of bad aliasing","\\"Saved\\" overlay in data model UI in weird location on smaller screen","\\"Compare to the rest\\" action in drill-through menu looks busted","Autocomplete suggestions are not working for most of the database tables","Permissions paths validation is `GET` API endpoints is too strict; causes numerous endpoints to 500 if unknown entry is present","Main page loading spinner spins forever on API error","Cannot use Data Selector when going directly to a question in new tab (or browser refresh)","\\"Show error details\\" in Query Builder should be toggleable","No visual feedback when setting column properties in Admin > Data Model","QP/MBQL: `[:relative-datetime :current]` doesn't work inside `[:between]` filter","Icon on empty activity page is misaligned","Google Analytics updated Credentials aren't used for Connection","Google Analytics database connection stopped working.","Binning not working in table with a single row","Fix error in send-abandonment-emails task","Can't change Google Analytics DB settings","when adding google analytics as source, it's not clear that I have to enable the API"]},{"version":"v0.42.2","released":"2022-02-28","patch":true,"highlights":["Dashboards breaks when there's filters to cards that a user don't have permissions to view","Questions with Field Filter with widget type \\"None\\" will not show results","Can't combine saved questions on a dashboard card ","Setting a filter to \\"Locked\\" in Embedding question is not possible","Nested queries with long Data Model names causes failing query with incorrect aliasing","Dropdown list filtering not working, when there's nulls","BigQuery - nested query generating bad aliases, when columns are renamed in Data Model","Summarizing with implicit join does not allow subsequent joins and nested query","Databases shows sync-spinner and doesn't allow to remove it or do a forced sync"]},{"version":"v0.42.1","released":"2022-02-17","patch":true,"highlights":["Filter dropdown only allows filtering on \\"starts with\\"","Unable to filter dashboards for dashboard subscription emails","Dashboard filter with defaults, doesn't work if values are removed, query fails","Pulse Question Alert to Slack sending cropped images","Cannot remove Google Sign-in setup","Embed dashboard Field Filter cannot work when choosing single option","Custom expression - Count needs parentheses, but deletes them afterwards","Cannot open Model sidebar in some cases","BigQuery incorrectly aliasing, which can make the query fail","Filtering on nested questions causes error in Public and Embedding","BigQuery nested query with ambiguous columns causes error","Setting a filter to \\"Locked\\" in Embedding is not possible","Remove unused dep on aleph (and thus unused transient dep on Netty)","Oracle queries don't work when aliases (auto-generated or otherwise) contain double quotes or null characters","When no-data user views a nested question, then all editing options are exposed","When no-data user views a nested question, then \\"Ask question\\" and \\"Browse data\\" appears","Oracle fails queries on joins with tables with long display names","Pivot Table: Cannot change name of fields used for \\"values\\""]},{"version":"v0.42.0","released":"2022-02-08","patch":false,"highlights":["Waterfall static viz default settings","\\"By coordinates\\" map in People X-ray shows a nonsensical pin map","Pins do not appear on pin map","\\"Explore results\\" shown for no-data users resulting in blank screen when clicked","Blank screen when accessing Models with no-data user","Secret connection property file path is not retained when revisiting database edit page","Licensing page goes into reload-loop if token is expired","Descriptions missing in search results"," the Time picker AM and PM color can not be distinguished obviously","Horizontal scroll of pinned table doesn't work on Firefox","Metadata tooltip popup on colum header casues data table to reset for number columns that are all NULLs ","Certain visualization_settings can cause empty/missing columns on export","Postgres unnecessarily casts `timestamptz` and `date` columns to `timestamp` inside `date_trunc()` ","Alert Stopped email is Unhelpful","Exports ignore column ordering regression in v0.41.6","Premature calls to `to-sql` inside `sql.qp/->honeysql` methods","Visualization \\"auto-viz\\" doesn't keep existing settings, when changing fields returned","Can't add a filter if the value isn't in the field filters dropdown","Clean up database guide usability during configuration","defsetting `:tag` metadata should be on the arglists themselves, not the var","Clean up how we show deprecated database drivers","SQLite/Redshift/SQL Server/MySQL queries don't work correctly with multiple column aliases with same name but different case","Archived sub-collections are still showing in Permissions","Clean up how we show deprecated database drivers","XLSX exports are leaving temporary files, which can block instance from working","Add a way to return to previous page from sign in cases","Consolidate first db sync modal and X-ray selection","[Epic] Migrate Slack implementation from Bot to App","Improve Filters for 42","Clean Up Settings Navigation"]},{"version":"v0.41.6","released":"2022-01-14","patch":true,"highlights":["Specific visualization_settings can cause empty export","Cannot change Field Filter reference to another schema/table if viewing the question directly","Upgrade Log4j to 2.17.1","Names of schemas or namespaces in the Data Model should wrap","Broken layout on Data Model page on locales with longer text"]},{"version":"v0.41.5","released":"2021-12-16","patch":true,"highlights":["Upgrade Log4j to 2.16.0","X-rays fails if there's a filter in the question","XLSX export does not respect \\"Separator style\\"","One cannot change any of the LDAP Settings once it's been initially setup","Custom Expression `coalesce` is using wrong field reference when nested query","Custom Expression `case` is using wrong field reference when nested query","Dashboard causes permission error, when \\"Click Behavior\\" linking to dashboard/question without access","Site URL validation too strict, doesn't accept underscore","Reverse proxy reset email should use site URL in email body and not localhost"]},{"version":"v0.41.4","released":"2021-12-10","patch":true,"highlights":[]},{"version":"v0.41.3.1","released":"2021-12-02","patch":true,"highlights":["BigQuery and Google Analytics drivers broken on x.41.3","BigQuery connection error on 0.41.1"]},{"version":"v0.41.3","released":"2021-12-01","patch":true,"highlights":["Static viz creates Picaso painting, when data is unordered Timeseries","Harmonize Google dependency versions, which could cause conflict between GA and new BigQuery driver","Saving/updating questions can take a very long time (seconds or minutes) on large instances","Funnel chart showing retained NaN% when all rows from aggregate column are zero","Changing a (old) pivoted table to less than 3 columns results in blank screen","Exports fails, when there's invalid visualization `column_settings` references","Cannot send test emails before creating subscription, when using non-default filter values","Native editor autocomplete suggestions makes object lookup without `limit`","Strip whitespace from Google sign-in client IDs","Validate Google sign-in client IDs","Dashboard causes permission error, when \\"Click Behavior\\" linking to dashboard/question without access","Clicking on legend in native question breaks the UI","Trend tile on dashboard differs from tile on full screen"]},{"version":"v0.41.2","released":"2021-11-09","patch":true,"highlights":["Frontend crashes when opening admin database permissions page","Cannot access Notebook for questions that uses a Custom Column as joining column","Requests to `GET /api/card/123` is making slow queries on larger instances","BigQuery can cause conflict with some column names like `source`","\\"Verify this question\\" button is shown even when content moderation feature is not enabled","New BigQuery driver with \\"Project ID (override)\\" defined causes different Field Filter references","Dashboard subscription send by Email fails with xlsx attachements","Textbox markdown links on images difficult to click","Some questions with old field dimensions or changed columns cannot be viewed, because of Javascript loop","Multi-column join interface defaults binning for numeric fields causing incorrect results","Sandboxing queries fails with caching is enabled","Changing redshift db details leads to closed or broken resource pool","Audit visualizations does not show correct information, when there's more than 1000 aggregated dates","\\"Set up your own alert\\" text needs padding ","Dashboard Subscriptions are not deactivated, when dashboard is archived","Update Uberjar builds on CircleCI to new build script","ED25519 keys not working for built-in SSH tunnels","Pin Maps with more than 1000 results (LeafletTilePinMap) not working with native queries"]},{"version":"v0.41.1","released":"2021-10-21","patch":true,"highlights":["Not all endpoints are called, when doing FullApp embedding","XLSX export of large columns fails because of formatting limitations","Caching on 0.41.0 caches results for very long time (does not respect settings defined)","Exporting large amount of data can result in OutOfMemory","Chart descriptions (except table) is not shown in dashboards","Better approach for column ordering in exports","Remapped (display value) columns are dropped in downloads","Tools for fixing errors problems with postgres semantics of limits (blank display of error table)","Filtering null-column via the drill-through action menu causes blank screen","Data Model shows blank page if there are any hidden tables in the database","Columns missing from exports, when viz settings are using older field dimensions","Pulses with rounded floats render a hanging decimal point in 0.41.0","Raise MB_DB_CONNECTION_TIMEOUT_MS to 10000 as default","Pulse/Subscription table cards with two columns (string, integer) fail to render","[Add Database > Presto] Multiple JDBC field options","Impossible to choose fields from different schema on Field Filters","In email subscription, the original question title is shown instead of the curated title (v41)","Audit > Questions > Total runtime displays link instead of an actual time","KeyExchange signature verification failed for key type=ssh-rsa","Export to XLSX can fail, when there's a very high integer value","Questions -> all questions in Audit feature sorts by null values","Allow caching of fonts and images","Dashboard Subscription test email button does not show error messages","EE Audit App frontend does not display error messages if queries fail","Dashboard Textbox does not render links unless using Markdown","Pin map only containing null location results causes the frontend to constantly reload or blank page","X-Rays: Table field is shown as \\"null\\" in the title","Custom Column with the same name as a table column returns incorrect results when grouped","Adding data series to dashboard widget lags then sometimes hangs the UI"]},{"version":"v0.41.0","released":"2021-10-06","patch":false,"highlights":["Went setting up multiple Dashboard Subscriptions, \\"Send email now\\" always sends the first one you set up until you refresh the page","Pull in translations for 0.41","Export in 0.41.0-rc1 does not include aggregated columns","Whitelabel color options are not translatable","Error inserting to view_log in 41-RC1","Fix filter alignment in emails with many or long values","Whitelabel includes `Metabase` in the subject for Alerts","XLSX download fails, when settings still has the old `k:mm` hour-format instead of `HH:mm`","History of last edited questions","Search fields in `Tools > Errors` should be disabled when there are no questions","\\"Rerun Selected\\" button is always enabled (even when there are no broken questions)","Dragging dashboards filters makes them hidden while dragging","Fix x-ray dashboards crash on first open","Fix Audit logging not showing ad-hoc native queries","X-ray dashboards crash on first opening","Send to Slack/Send email now buttons on dashboard subscriptions send the wrong dashboard","master - the upper-corner Run/Reload button has become very big","Schemas with only hidden tables are shown in the data selector","Saved Question: changing the breakout field (summarize) removes order-by (sort)","Notebook Join UI display wrong table name with multiple join (master)","Active filter widget are not using whitelabel color on border","Data point value can be slightly cut-off for the top Y-axis values","Dashboard sticky filter section is visible even when there aren't any filters","Click Behavior does not work with old Pivot","BigQuery Custom Column difficult to use because of name restrictions","Revision history does not update until page reload","Visualizations are not always using whitelabel colors by default","BigQuery Custom Expression function `Percentile` and `Median` not using correct backtick quoting","BigQuery `BIGNUMERIC` is recognized as `type/*` and displayed as string","Joining behavior on datetime columns needs to be clearer"]},{"version":"v0.40.5","released":"2021-09-21","patch":true,"highlights":["???? backported \\"GeoJSON URL validation fix\\"","Grid map causes frontend reload or blank screen, when hovering the grids if there is no metric","Cannot create more than 2 metrics, when UI language is Turkish - screen goes blank or displays \\"Something went wrong\\"","Visualizations with more than 100 series just shows a blank chart","Data point values uses formatting Style of first serie on all series"]},{"version":"v0.40.4","released":"2021-09-09","patch":true,"highlights":["Dashboard filter autocomplete not working with mixed Search/Dropdown when dropdown has a `null` value","Not possible to delete Dashboard Subscription unless dashboard is in root collection","Possible to not input recipient of Subscription, which will then cause blank screen","Valid Email settings disappear on save, but re-appear after refresh","Unable to click \\"Learn more\\" on custom expression","Editing an alert causes it to be deleted in some circumstances","New databases with \\"This is a large database ...\\" still uses the default sync+scan settings","Adding cards to dashboard via search can cause the card to show spinner until browser refresh","Cannot login with OpenAM SAML since 1.38.3","Native question \\"Filter widget type\\"=\\"None\\" hides the filter widget even after changing it to something else"]},{"version":"v0.40.3.1","released":"2021-08-26","patch":true,"highlights":[]},{"version":"v0.40.3","released":"2021-08-25","patch":true,"highlights":["???? backported \\"Keep `collection_id` of dashboard subscriptions in sync with same field on dashboard\\"","Run-overlay not going away on GUI question","Dashboard causes scrollbars to constantly go on/off depending on viewport size ","Serialization `--mode skip` incorrectly updates some objects","Serialization crashes on dump if there's no collections","Serialization: Cannot load into empty/blank target","Clicking the column formatting button when the sidebar is already open should correctly open that column's formatting sidebar","Dashboard Subscription doesn't follow the order of the cards on the dashboard","Clicking away from Sandbox modal breaks perms page"]},{"version":"v0.40.2","released":"2021-08-03","patch":true,"highlights":["Update strings for 0.40.2","Docs for 40.2","Snippet folder permissions are always applied to root","Cannot start development in VS Code because of missing Node.js","Search widget on question builder hangs tab, API field search limit not respected","Only 50 groups are displayed","People search dropdown goes outside of the screen","Only 50 users shown in email autocomplete and \\"Other user's personal collection\\"","Dashboard - Adding ???Click Behavior??? to an image field converts image to URL","Cannot upgrade to v0.40.x on AWS Elastic Beanstalk due to AWS Inspector not being available in certain regions","Add Metabase Cloud link to admin settings for hosted instances","Fix dashboard card hovering buttons drag behaviour","Elastic Beanstalk nginx config is not updated on latest EB docker images","Cannot deactivate users after the first 50 users","Tabs in the Audit section look broken","Duplication of the displayed table","Allow selecting text in Textbox cards, while dashboard is in edit-mode","Metabase on old AWS Elastic Beanstalk (Amazon Linux w/ old Docker) upgrade to 0.40 failed","Popover footer is displaced when using filter with a search input","Public Sharing footer is double-size because action buttons are stacked","Error when setting column type to Number in data model settings","Site URL can sometimes be incorrectly defined during startup","Padding needed for button on map settings page","LDAP/Email settings gets cleared if validation fails","Serialization: Visualization column settings lost","Waterfall visualization does not work with ordinal X-axis","Clicking \\"Cancel\\" on collection archive modal should let you stay in that same collection","Snowflake Connector Requires Deprecated Region Id","Modify instead of replace default EB nginx config"]},{"version":"v0.40.1","released":"2021-07-14","patch":true,"highlights":["An error occurs when opening a public question with filters having default parameters","Remove Multi-Release from manifest","Questions filters does not work in Embedded/Public","Long titles in collections push out the last-edited-by and last-edited-at columns","Only first 50 databases are displayed","After hiding the column and then setting a required default value for SQL field filter (connected to that column) shows all fields as hidden and breaks SQL filters completely","Global search suggestions dropdown appears behind the dataset search widget when starting a simple question","Clean up the user-facing strings for coercion options","Clicking Visualize in Notebook makes the question \\"dirty\\" even if no changes was made"]},{"version":"v0.40.0","released":"2021-07-08","patch":false,"highlights":["Avoid error when user searches with no data perms","Updated saved question data picker - styling improvements","The pinned items from the main collection are not showed on the front page anymore","[0.40 blocker] Handle personal collections better in the new saved question data picker","Remove \\"Something went wrong\\"","Filter flag causes overlay for required \\"Number\\" filter with the default value set","Do not show Cloud CTA for Enterprise Edition","The list of collections available on homepage \\"Our analytics\\" depends on the name of the first 50 objects","Filter feature flag causes Run-overlay of results in Native editor unless editor is expanded","Error message missing when logging in to a disabled account with Google sign-in","unix-timestamp->honeysql implementation for h2 is incorrect for microseconds","Fix funnel appearance","Confusing UI when adding GeoJSON with no identifiers","Better error handling when adding malformed GeoJSON","Can't archive a question from the Question page","Can't move item to \\"Our analytics\\" using drag-n-drop","Can't \\"Select All\\" collection items if all items are pinned","Bulk archive doesn't work","Selecting bin count on intermediate data question fails","Collections Metadata FE Implementation","Group by on a `:Coercion/YYYYMMDDHHMMSSBytes->Temporal` postgres column fails","Double binning menu for date fields when using Saved Question (Native)","Cannot filter only on longitude/latitude range - UX is forcing user to fill out values for both fields","Bug in values on data points for waterfall charts","Table view on Permissions shows error on browser refresh","Password login on SSO instance drops the redirect URL","No error is reported when adding SQLite database that doesn't exist","Specific combination of filters can cause frontend reload or blank screen","Dashboard Contains filter doesn't remain when clicking on Question title","Normal login errors are not surfaced if SSO is also active"]},{"version":"v0.39.4","released":"2021-06-16","patch":true,"highlights":["Javascript error when enabling JWT authentication","Switch to column settings when sidebar is already open","Questions on MongoDB return 'No results!' after upgrade from 0.38.5 to 0.39.0 when filtering against array ","Login blocked till timeout if Metabase can't reach GeoJS API","Missing tooltip for sharing individual question","Histograms should filter out null x values","Shifted chart values on line with ordinal x axis","Don't show Custom Expression helper, when input is not in focus","Dashboard filters dropdown only list the first 100 values","Cannot use arithmetic between two `case()` function in Custom Expression","LDAP login fails with Group Sync when user is assigned to 1 group","LDAP auth errors with \\"did not match stored password\\" if `givenName` or `sn` is missing","Cannot join Saved Questions that themselves contains joins","Human-reable numering not working properly","Time series filter and granularity widgets at bottom of screen are missing","LDAP group sync - LDAPException after removing user from a mapped group","Dashboard text cards aren't scrolling"]},{"version":"v0.39.3","released":"2021-05-27","patch":true,"highlights":["Feature flag causes problems with Number filters in Native query","Revoking access to users in multiple groups does not correctly cleanup GTAP","LDAP settings form hitting wrong API endpoint on save","ExpressionEditor loses value when user resizes browser window","ExpressionEditor loses value when user clicks away from associated name input","Filter dropdown not working for non-data users, when field has 300+ distinct values.","Tooltip only shows first Y-axis value when X-axis is numeric and style is Ordinal/Histogram","Gauge visualization on small screens can cause frontend refresh on hover","Serialization: `field-literal` converted to `field` since 1.39.0","Serialization dumps with static references instead of paths in 1.39.0","Fix Serialization P1s","Incorrect result + loss of user input when summarizing with Saved Question","Some places shows `{0}` placeholder instead of expected value","Serialization load-process does not update `source-table` in joins, leading to broken questions","Unchecking \\"Remember me\\" box has no effect -- close the browser and reopen, then go back to your MB instance and you're still logged in","Serialization `dump` includes Personal Collections","Serialization: Nested question references questions in other collection are moved and becomes corrupted","Serialization: Snippet folders and Collections collide on `dump` because of missing namespace separation","Serialization: Snippets are not transferred correctly, leading to incorrect references and broken queries","Serialization: Click Behavior not translating entitiy ID on dump, potentially referencing wrong entities on load","Wrong LDAP port input (non-numeric) can cause complete lockout","Nested queries using metric got wrong SQL","Cannot aggregate question with unix timestamp column that is converted/cast in Metabase","Test LDAP settings before saving","Nested queries using metrics need to include all columns used in metric filters"]},{"version":"v0.39.2","released":"2021-05-17","patch":true,"highlights":["Regression combining Druid date filters with dimension filters","Regression in filtering Druid table where greater than date","Variable Field Type after upgrade \\"Input to parse-value-to-field-type does not match schema\\"","Whitelabel favicon does not work correctly in all browsers","Show right versions on enterprise custom builds","Not possible to select pinned collection item using checkbox","The new \\"contains\\" behavior for field value lookup doesn't work outside of dashboards","Cannot restore table visibility in Data Model, when database is down","LDAP user authorization failed with `$` in password","Difficult to use some filters, when user has no data permissions [FE - Filter widget stops working if API endpoint returns 403]","Serialization: Dashboard cards are corrupted, when questions are outside of dashboard collection","Collection tree loader causes UI jump","Filters with dropdown lists uses query on the database","Login Failing for LDAP if user email isn't lowercase","Startup warning about unsupported class will impact performance","Auth Returns 400 Bad Request instead of 401 Unauthorized upon wrong credentials submission","Need better instructions for setting up Google Auth"]},{"version":"v0.39.1","released":"2021-04-27","patch":true,"highlights":["Tooltip shows incorrect values on unaggregated data with breakout","Can't use parentheses as expected in filter expressions","UI prevents adding 2 parameters to `Percentile()` function","Login logo is left-aligned on EE, when whitelabel features are enabled","No loading spinner when clicking a Collection on the home page","Tooltip on unaggregated data does not show summed value like the visualization","Table with multiple Entity Key columns incorrectly filtering on \\"Connected To\\" drill-through"]},{"version":"v0.39.0.1","released":"2021-04-20","patch":false,"highlights":["Cannot select category Field Filter in Native query on 0.39.0","map category/location to string so we can treat them like string/= in UI"]},{"version":"v0.39.0","released":"2021-04-19","patch":false,"highlights":["Strings with placeholders like {0} aren't translating correctly","Wrong tooltip labels and values for multiple series charts in dashboard","Add feature flag for the new 0.39.0 dashboard filter types","Pulse fails when visualization_settings is referring to a field-literal column","Login History not recording correct IP address","Add an ENV var setting for typeahead search","BigQuery with filter after aggregation of join table fails query with wrong alias reference on 38.x","Dashboard Textbox images are 100% width","Questions based on Saved Questions is not using the same query for date filters leading to wrong results","0.39 string translations","0.39 Docs","Add missing \\"is\\" assertions to various tests","Custom Expression autocomplete operator selection is appended to what was typed","Custom Expression formula starts with high cursor placement on Firefox","Custom Expression filter not setting the \\"Done\\" button to current state of the formula until onblur","Custom Expression editor is removing spaces too aggressive","Hitting return when modifying a custom expression incorrectly discards changes","metabase/metabase-enterprise-head Docker image doesn't have enterprise extensions","Custom expressions: UI is too wide when shown in the sidebar","Search: some results are as being in a folder which doesn't exist in the data reference","Error saving metric in data reference","Dashboard Subscription Filters: Set Parameter Values","Normalize queries in URL fragments on FE","Support string and number filter operators in dashboard parameter filters ","defsetting macro throw an Exception if you try to define a setting that's already defined in a different namespace","Fix render error when removing a dashboard parameter","Upgrade HoneySQL version to latest","Dashboard Filter Improvements (to support large-scale rollout)","SSH Connectivity Improvements","MBQL Refactor: Combine various Field clauses into one new clause"]},{"version":"v0.38.4","released":"2021-04-12","patch":true,"highlights":["Not possible to position Y-axis if there's only one series","Tooltip on unaggregated data does not show summed value like the visualization","For a new Custom column, I can set Style to \\"Currency\\", but cannot choose the Unit of Currency","Add Kyrgyz Som to currency list"]},{"version":"v0.38.3","released":"2021-04-01","patch":true,"highlights":["Overflow text on Ask a question page ","Filtering on coerced column doesn't always know its coerced","Wrong series label in multiple series scatterplot","Dashboard Subscription fails for all SQL questions with a Field Filter on date column connected on dashboard","Dashboard Subscription Emails do not work with filtered Native Queries","Dashboard Subscription sidebar broken for Sandboxed users","Provide more logging information on permission errors when creating Cards"," In Settings > Email, Save Changes is enabled even when there are no changes","Exports always uses UTC as timezone instead of the selected Report Timezone","Invalid Redirect Location After SAML Sign-in via Full App Embed","Cannot download XLSX if there's more than 1 million results","Frontend load issue: SMTP Email","Pie chart sometimes does not show total","Users with collections \\"edit\\" permissions and no data access permissions can't edit question metadata","Add Bitcoin as a unit of currency","Column \\"Custom title\\" not working in tooltips","Schema sync does not update changes in column type case","Error on visualization change of a question with SQL queries view only permission","Line chart dots don't have `cursor: pointer` when hovering"]},{"version":"v0.38.2","released":"2021-03-17","patch":true,"highlights":["Data model not showing PostgreSQL tables when they are partitioned","Migrate old pre-1.37 \\"Custom Drill-through\\" settings to x.37+ \\"Click Behavior\\"","Regression with URL links"]},{"version":"v0.38.1","released":"2021-03-03","patch":true,"highlights":["Serialization `dump` of aggregated questions are not copied over on `load`","Serialization doesn't update Sub-Query variable reference","Oracle, BigQuery filtering by column with day-of-week bucketing not working","Pivot Table export not working on unsaved questions","Pivot Table does not work for users without data permissions","Pivot Table not working with Sandboxed user","BigQuery: Joins in the query builder generate invalid table aliases","BigQuery: Question Stays running until timeout when query is error in Native Query","Serialization: Archived items are included in `dump`","Breadcrumbs can be confusing (the current one \\"seems\\" clickable when it's not)","regexextract breaks query on sandboxed table","Multi-level aggregations fails when filter is the last section","Pivot queries aren't recorded to query execution log","Start of Week not applied to Field Filter in Native question, which can lead to incorrect results","In Safari 14, add-grouping button disappears randomly but consistently","Serialization does not initialize 3rd party drivers when loading a dump","Wrong day names are displayed when using not-Sunday as start of the week and grouping by \\"Day of week\\"","Difficult to see which cells has \\"Click behavior\\" vs normal behavior","Object Detail previous/next buttons not working correctly","Global number formatting does not apply to percentages","Native question filter widget reordering doesn't work"]},{"version":"v0.38.0.1","released":"2021-02-19","patch":false,"highlights":[]},{"version":"v0.38.0","released":"2021-02-16","patch":false,"highlights":["Sandboxed question with `case` Custom Field doesn't substitute the \\"else\\" argument's table","Custom Expression using `case()` function fails when referencing the same column names","Filtering a Custom Column does not give correct results when using \\"Not equal to\\"","Cannot remove columns via QB sidebar, then query fails, but works if being removed via Notebook","fix(rotate-encryption-key) settings-last-updated is not encrypted","For Pivot Tables, download popup doesn't show","Dashboard Subscriptions: Have to click the close button multiple times after viewing a Subscription","Advanced Sandboxing ignores Data Model features like Object Detail of FK","Publish \\"latest\\" OSS JAR","Custom GeoJSON files are not sorted in the dropdown","user@password JDBC connection strings for application DB no longer work","Shrunken bubbles shown in question for null values","Drilling down by a Region Map assigns the wrong value to the filter","Using \\"Reset to defaults\\" on textbox causes it to become a corrupted card on dashboard","Add a lightweight notify api endpoint","Sandboxing on tables with remapped FK (Display Values) causes query to fail","Allow usage of PKCS-12 certificates with Postgres connections","dump-to-h2 does not return a non-zero exit code on failure","Advanced Sandboxing using questions that return more/other columns than the sandboxed table is not possible anymore, but the errors are not helpful","Bar chart x-axis positions can cause different spacing depending on the dates returned","Custom Columns breaks Pivot Table","Pivot tables broken on dashboard after resize","dump-to-h2 with --dump-plaintext should check for presence of MB_ENCRYPTION_SECRET_KEY","Right alignment of pivot table value cells looks broken","Don't inform admins about MB cloud on EE instances","add cmd rotate-encryption-key","Token check retry is too aggressive","Login page should automatically focus on the email input field","Dashboard subscriptions including cards no longer in dashboard","UI should update when a collection changes parent"]},{"version":"v0.37.9","released":"2021-02-11","patch":true,"highlights":[]},{"version":"v0.37.8","released":"2021-01-29","patch":true,"highlights":["Cannot add (date) filter if calendar is collapsed"]},{"version":"v0.37.7","released":"2021-01-20","patch":true,"highlights":[]},{"version":"v0.37.6","released":"2021-01-13","patch":true,"highlights":[]},{"version":"v0.37.5","released":"2021-01-05","patch":true,"highlights":["Linked filters breaking SQL questions on v0.37.2","Embedding loading slow","Cannot toggle off 'Automatically run queries when doing simple filtering and summarizing' "]},{"version":"v0.37.4","released":"2020-12-17","patch":true,"highlights":["Error in Query: Input to aggregation-name does not match schema","Revert #13895","Exports always uses UTC as timezone instead of the selected Report Timezone","Between Dates filter behaves inconsistently based on whether the column is from a joined table or not"]},{"version":"v0.37.3","released":"2020-12-03","patch":true,"highlights":["Fix chain filtering with temporal string params like 'last32weeks'","Linked filters breaking SQL questions on v0.37.2","Running with timezone `Europe/Moscow` shows Pulse timezone as `MT` instead of `MSK` and sends pulses on incorrect time","Order fields to dump by ID","Remove object count from log output"]},{"version":"v0.37.2","released":"2020-11-16","patch":true,"highlights":["When visualization returns `null` (No results), then UI becomes broken"]},{"version":"v0.37.1","released":"2020-11-12","patch":true,"highlights":["Table schema sync performance impact","v0.37.0.2 doesn't sync Vertica schema","Pie chart shows spinner, when returned measure/value is `null` or `0`","Wrong day names are displayed when using not-Sunday as start of the week and grouping by \\"Day of week\\"","When result row is `null`, then frontend incorrectly shows as \\"No results!\\"","Snowflake tables with a GEOGRAPHY column cannot be explored","Cannot edit BigQuery settings without providing service account JSON again","Sync crashes with OOM on very large columns/row samples [proposal]","500 stack overflow error on collection/graph API call","Custom Column after aggregation creates wrong query and fails","The expression editor shouldn't start in error mode without any user input","Pulse attachment file sent without file extension","Metric with unnamed Custom Expression breaks Data Model for table","Nested queries with duplicate column names fail","pulse attachment file(question name) Korean support problem","Pulse Bar Chart Negative Values Formatting"]},{"version":"v0.37.0.2","released":"2020-10-26","patch":false,"highlights":[]},{"version":"v0.36.8.2","released":"2020-10-26","patch":true,"highlights":[]},{"version":"v0.37.0.1","released":"2020-10-23","patch":false,"highlights":[]},{"version":"v0.36.8.1","released":"2020-10-23","patch":true,"highlights":[]},{"version":"v0.37.0","released":"2020-10-22","patch":false,"highlights":["Fix null handling in filters regression","Add translation for Bulgarian","0.37.0-rc3: Click behavior to Dashboard shown on Public/Embedded","NO_COLOR/MB_COLORIZE_LOGS does not remove all ansi codes","0.37.0-rc3: Filtering a joined table column by \\"Is not\\" or \\"Does not contain\\" fails","Update translations for final 0.37 release","0.37.0-rc2: Monday week start displays incorrectly on bar chart","0.37.0-rc2: Linked filter showing all values (not filtering)","Only get substrings in fingerprinting when supported [ci drivers]","0.37.0-rc2: log4j should not output to file by default","0.37-RC2: we should suppress drag behavior when custom click behavior is set","0.37-RC2: disable Done button in cases where click behavior target isn't specified","0.37-RC2: weird edit state when saving a dashboard with incomplete click behavior","0.37-RC2: Interactivity summary tokens squashed on small dashboard cards","0.37.0-rc2: Hovering on custom map no longer displays region name, displays region identifier instead","0.37.0-rc1: \\"Click behavior\\" to URL for non-table card, doesn't show reference fields to use as variables","0.37.0-rc1: Variables from Saved Question are referencing the same question","0.37.0-rc2: Cannot create custom drill-through to dashboard","0.37-rc1: after clicking a custom link that passes a value to a param, clicking Back shouldn't bring that value to the original dashboard","0.37-rc1: When mapping dashboard filters to columns, SQL questions should display the name of the column mapped to the field filter","0.37-rc1: customizing a dashboard card's click behavior without specifying a destination causes strange behavior","0.37-rc1: canceling the dashboard archive action takes you to the collection","Embedded versions of new chain filters endpoints ","\\"Does not contain\\" and \\"Is not\\" filter also removes nulls","Docs - 37 release - new dashboard functionality","forward slash on table name causes ORA-01424 and blocks the sync step","Update login layout and illustration.","MySQL grouping on a TIME field is not working","Field Filter variables in SQL question don???t show table name when connecting filters in dashboard","Upgrade to log4j 2.x"]},{"version":"v0.36.8","released":"2020-10-22","patch":true,"highlights":[]},{"version":"v0.36.7","released":"2020-10-09","patch":true,"highlights":["Presto not respecting SSL and always uses http instead of https","Footer (with export/fullscreen/refresh buttons) on Public/Embedded questions disappears when using Premium Embedding","Postgres sync not respecting SSH tunneling"]},{"version":"v0.36.6","released":"2020-09-15T22:58:04.727Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.36.5.1","released":"2020-09-11T23:16:26.199Z","patch":true,"highlights":["Remappings should work on broken out fields"]},{"version":"v0.36.4","released":"2020-08-17T22:41:20.449Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.36.3","released":"2020-08-04T23:57:45.595Z","patch":true,"highlights":["Support for externally linked tables"]},{"version":"v0.36.2","released":"2020-07-31T17:46:34.479Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.36.1","released":"2020-07-30T18:10:44.459Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.36.0","released":"2020-07-21T19:56:40.066Z","patch":false,"highlights":["SQL/native query snippets","Language selection"]},{"version":"v0.35.4","released":"2020-05-29T17:31:58.191Z","patch":true,"highlights":["Security fix for BigQuery and SparkSQL","Turkish translation available again","More than 20 additional bug fixes and enhancements"]},{"version":"v0.35.3","released":"2020-04-21T21:18:24.959Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.35.2","released":"2020-04-10T23:03:53.756Z","patch":true,"highlights":["Fix email and premium embedding settings","Fix table permissions for database without a schema","Fix \\"Error reducing result rows\\" error"]},{"version":"v0.35.1","released":"2020-04-02T21:52:06.867Z","patch":true,"highlights":["Issue with date field filters after v0.35.0 upgrade","Unable to filter on manually JOINed table"]},{"version":"v0.35.0","released":"2020-03-25T18:29:17.286Z","patch":false,"highlights":["Filter expressions, string extracts, and more","Reference saved questions in your SQL queries","Performance improvements"]},{"version":"v0.34.3","released":"2020-02-25T20:47:03.897Z","patch":true,"highlights":["Line, area, bar, combo, and scatter charts now allow a maximum of 100 series instead of 20.","Chart labels now have more options to show significant decimal values.","Various bug fixes"]},{"version":"v0.34.2","released":"2020-02-05T22:02:15.277Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.34.1","released":"2020-01-14T00:02:42.489Z","patch":true,"highlights":["Various bug fixes"]},{"version":"v0.34.0","released":"2019-12-20T01:21:39.568Z","patch":false,"highlights":["Added support for variables and field filters in native Mongo queries","Added option to display data values on Line, Bar, and Area charts","Many Timezone fixes"]},{"version":"v0.33.7.3","released":"2019-12-17T01:45:45.720Z","patch":true,"highlights":["Important security fix for Google Auth login"]},{"version":"v0.33.7","released":"2019-12-13T20:35:14.667Z","patch":true,"highlights":["Important security fix for Google Auth login"]},{"version":"v0.33.6","released":"2019-11-19T20:35:14.667Z","patch":true,"highlights":["Fixed regression that could cause saved questions to fail to render (#11297)","Fixed regression where No Results icon didn't show (#11282)","Pie chart visual improvements (#10837)"]},{"version":"v0.33.5","released":"2019-11-08T20:35:14.667Z","patch":true,"highlights":["Added Slovak translation","Fixed support for MySQL 8 with the default authentication method","Fixed issues with X-axis label formatting in timeseries charts"]},{"version":"v0.33.4","released":"2019-10-08T20:35:14.667Z","patch":true,"highlights":["Custom expression support for joined columns","Fixed issue with filtering by month-of-year in MongoDB","Misc Bug Fixes"]},{"version":"v0.33.3","released":"2019-09-20T08:09:36.358Z","patch":true,"highlights":["Chinese and Persian translations now available again","Misc Bug Fixes "]},{"version":"v0.33.2","released":"2019-09-04T08:09:36.358Z","patch":true,"highlights":["Fixed Cards not saving","Fixed searrch not working "]},{"version":"v0.33.1","released":"2019-09-04T08:09:36.358Z","patch":true,"highlights":["Fixed conditional formatting not working","Fixed an issue where some previously saved column settings were not applied ","Fixed an issue where pulses were not loading "]},{"version":"v0.33.0","released":"2019-08-19T08:09:36.358Z","patch":false,"highlights":["Notebook mode + Simple Query Mode","Joins","Post Aggregation filters"]},{"version":"v0.32.10","released":"2019-07-28T08:09:36.358Z","patch":true,"highlights":["Fix User can't logout / gets automatically logged in.","Fix No data displayed when pivoting data","Fixed Dashboard Filters on Linked Entities Broke"]},{"version":"v0.32.9","released":"2019-06-14T08:09:36.358Z","patch":true,"highlights":["Fix issues connecting to MongoDB Atlas Cluster","Fix database addition on setup","Fixed numeric category error with Postgres"]},{"version":"v0.32.8","released":"2019-05-13T08:09:36.358Z","patch":true,"highlights":["Fix i18n"]},{"version":"v0.32.7","released":"2019-05-09T08:09:36.358Z","patch":true,"highlights":["Fix published SHA Hash"]},{"version":"v0.32.6","released":"2019-05-08T12:09:36.358Z","patch":true,"highlights":["Fixed regression where Dashboards would fail to fully populate","Performance improvements when running queries","Security improvements"]},{"version":"v0.32.5","released":"2019-04-20T12:09:36.358Z","patch":true,"highlights":["Improve long-running query handling","Fix H2 to MySQL/Postgres migration issue","Fix issue with embedded maps with custom GeoJSON"]},{"version":"v0.32.4","released":"2019-04-09T12:09:36.358Z","patch":true,"highlights":["Fix issue where Google Auth login did not work","FFix issue where Google Auth login did not work"]},{"version":"v0.32.3","released":"2019-04-08T12:09:36.358Z","patch":true,"highlights":["Fixed Snowflake connection issues","Fixed Dashboard copy","Fixed non-root context logins"]},{"version":"v0.32.2","released":"2019-04-03T12:09:36.358Z","patch":true,"highlights":["Fixed dashboard date filters ","Fixed SSL error using Quartz w/ MySQL","Fix colors in dashboards"]},{"version":"v0.32.1","released":"2019-03-29T12:09:36.358Z","patch":true,"highlights":["Fixed MySQL connections with SSL","Fixed table sync issue"]},{"version":"v0.32.0","released":"2019-03-28T12:09:36.358Z","patch":false,"highlights":["Modular Drivers (reducing memory consumption)","Async queries (improving responsiveness)","Reduced memory consumption."]},{"version":"v0.31.2","released":"2018-12-07T12:09:36.358Z","patch":true,"highlights":["Added German translation","Fixed Heroku out-of-memory errors","Fixed issue with Slack-based Pulses due to rate limiting."]},{"version":"v0.31.1","released":"2018-11-21T12:09:36.358Z","patch":true,"highlights":["Ability to clone dashboards","Faster startup time and lower memory consumption","Migration issue fixes."]},{"version":"v0.31.0","released":"2018-11-08T12:09:36.358Z","patch":false,"highlights":["New visualizations and combo charts","Granular formatting controls","Snowflake Support"]},{"version":"v0.30.4","released":"2018-09-27T12:09:36.358Z","patch":true,"highlights":["Metabase fails to launch in Chinese","Fix token status checking","Fix BigQuery SQL parameters with encrypted DB details"]},{"version":"v0.30.3","released":"2018-09-13T12:09:36.358Z","patch":true,"highlights":["Localization for Chinese, Japanese, Turkish, Persian","Self referencing FK leads to exception","Security improvements"]},{"version":"v0.30.2","released":"2018-09-06T12:09:36.358Z","patch":true,"highlights":["Localization for French + Norwegian","Stability fixes for HTTP/2"]},{"version":"v0.30.1","released":"2018-08-08T12:09:36.358Z","patch":true,"highlights":["Localization for Portuguese","Timezone fix","SQL Template tag re-ordering fix"]},{"version":"v0.30.0","released":"2018-08-08T12:09:36.358Z","patch":false,"highlights":["App wide search","Enhanced Collection permissions","Comparison X-Rays"]},{"version":"v0.29.3","released":"2018-05-12T12:09:36.358Z","patch":true,"highlights":["Fix X-ray rules loading on Oracle JVM 8"]},{"version":"v0.29.2","released":"2018-05-10T12:09:36.358Z","patch":true,"highlights":["Fix Spark Driver"]},{"version":"v0.29.1","released":"2018-05-10T11:09:36.358Z","patch":true,"highlights":["Better heroku memory consumption","Fixed X-Ray Bugs","Drill through from line chart selects wrong date"]},{"version":"v0.29.0","released":"2018-05-01T11:09:36.358Z","patch":false,"highlights":["New and Improved X-Rays","Search field values","Spark SQL Support"]},{"version":"v0.28.6","released":"2018-04-12T11:09:36.358Z","patch":true,"highlights":["Fix chart rendering in pulses"]},{"version":"v0.28.5","released":"2018-04-04T11:09:36.358Z","patch":true,"highlights":["Fix memory consumption for SQL templates","Fix public dashboards parameter validation","Fix Unable to add cards to dashboards or search for cards, StackOverflowError on backend"]},{"version":"v0.28.4","released":"2018-03-29T11:09:36.358Z","patch":true,"highlights":["Fix broken embedded dashboards","Fix migration regression","Fix input typing bug"]},{"version":"v0.28.3","released":"2018-03-23T11:09:36.358Z","patch":true,"highlights":["Security improvements"]},{"version":"v0.28.2","released":"2018-03-20T11:09:36.358Z","patch":true,"highlights":["Security improvements","Sort on custom and saved metrics","Performance improvements for large numbers of questions and dashboards"]},{"version":"v0.28.1","released":"2018-02-09T11:09:36.358Z","patch":true,"highlights":["Fix admin panel update string","Fix pulse rendering bug","Fix CSV & XLS download bug"]},{"version":"v0.28.0","released":"2018-02-07T11:09:36.358Z","patch":false,"highlights":["Text Cards in Dashboards","Pulse + Alert attachments","Performance Improvements"]},{"version":"v0.27.2","released":"2017-12-12T11:09:36.358Z","patch":true,"highlights":["Migration bug fix"]},{"version":"v0.27.1","released":"2017-12-01T11:09:36.358Z","patch":true,"highlights":["Migration bug fix","Apply filters to embedded downloads"]},{"version":"v0.27.0","released":"2017-11-27T11:09:36.358Z","patch":false,"highlights":["Alerts","X-Ray insights","Charting improvements"]},{"version":"v0.26.2","released":"2017-09-27T11:09:36.358Z","patch":true,"highlights":["Update Redshift Driver","Support Java 9","Fix performance issue with fields listing"]},{"version":"v0.26.1","released":"2017-09-27T11:09:36.358Z","patch":true,"highlights":["Fix migration issue on MySQL"]},{"version":"v0.26.0","released":"2017-09-26T11:09:36.358Z","patch":true,"highlights":["Segment + Metric X-Rays and Comparisons","Better control over metadata introspection process","Improved Timezone support and bug fixes"]},{"version":"v0.25.2","released":"2017-08-09T11:09:36.358Z","patch":true,"highlights":["Bug and performance fixes"]},{"version":"v0.25.1","released":"2017-07-27T11:09:36.358Z","patch":true,"highlights":["After upgrading to 0.25, unknown protocol error.","Don't show saved questions in the permissions database lists","Elastic beanstalk upgrades broken in 0.25 "]},{"version":"v0.25.0","released":"2017-07-25T11:09:36.358Z","patch":false,"highlights":["Nested questions","Enum and custom remapping support","LDAP authentication support"]},{"version":"v0.24.2","released":"2017-06-01T11:09:36.358Z","patch":true,"highlights":["Misc Bug fixes"]},{"version":"v0.24.1","released":"2017-05-10T11:09:36.358Z","patch":true,"highlights":["Fix upgrades with MySQL/Mariadb"]},{"version":"v0.24.0","released":"2017-05-10T11:09:36.358Z","patch":false,"highlights":["Drill-through + Actions","Result Caching","Presto Driver"]},{"version":"v0.23.1","released":"2017-03-30T11:09:36.358Z","patch":true,"highlights":["Filter widgets for SQL Template Variables","Fix spurious startup error","Java 7 startup bug fixed"]},{"version":"v0.23.0","released":"2017-03-21T11:09:36.358Z","patch":false,"highlights":["Public links for cards + dashboards","Embedding cards + dashboards in other applications","Encryption of database credentials"]},{"version":"v0.22.2","released":"2017-01-10T11:09:36.358Z","patch":true,"highlights":["Fix startup on OpenJDK 7"]},{"version":"v0.22.1","released":"2017-01-10T11:09:36.358Z","patch":true,"highlights":["IMPORTANT: Closed a Collections Permissions security hole","Improved startup performance","Bug fixes"]},{"version":"v0.22.0","released":"2017-01-10T11:09:36.358Z","patch":false,"highlights":["Collections + Collections Permissions","Multiple Aggregations","Custom Expressions"]},{"version":"v0.21.1","released":"2016-12-08T11:09:36.358Z","patch":true,"highlights":["BigQuery bug fixes","Charting bug fixes"]},{"version":"v0.21.0","released":"2016-12-08T11:09:36.358Z","patch":false,"highlights":["Google Analytics Driver","Vertica Driver","Better Time + Date Filters"]},{"version":"v0.20.3","released":"2016-10-26T11:09:36.358Z","patch":true,"highlights":["Fix H2->MySQL/PostgreSQL migrations, part 2"]},{"version":"v0.20.2","released":"2016-10-25T11:09:36.358Z","patch":true,"highlights":["Support Oracle 10+11","Fix H2->MySQL/PostgreSQL migrations","Revision timestamp fix"]},{"version":"v0.20.1","released":"2016-10-18T11:09:36.358Z","patch":true,"highlights":["Lots of bug fixes"]},{"version":"v0.20.0","released":"2016-10-11T11:09:36.358Z","patch":false,"highlights":["Data access permissions","Oracle Driver","Charting improvements"]},{"version":"v0.19.3","released":"2016-08-12T11:09:36.358Z","patch":true,"highlights":["fix Dashboard editing header"]},{"version":"v0.19.2","released":"2016-08-10T11:09:36.358Z","patch":true,"highlights":["fix Dashboard chart titles","fix pin map saving"]},{"version":"v0.19.1","released":"2016-08-04T11:09:36.358Z","patch":true,"highlights":["fix Dashboard Filter Editing","fix CSV Download of SQL Templates","fix Metabot enabled toggle"]},{"version":"v0.19.0","released":"2016-08-01T21:09:36.358Z","patch":false,"highlights":["SSO via Google Accounts","SQL Templates","Better charting controls"]},{"version":"v0.18.1","released":"2016-06-29T21:09:36.358Z","patch":true,"highlights":["Fix for Hour of day sorting bug","Fix for Column ordering bug in BigQuery","Fix for Mongo charting bug"]},{"version":"v0.18.0","released":"2016-06-022T21:09:36.358Z","patch":false,"highlights":["Dashboard Filters","Crate.IO Support","Checklist for Metabase Admins","Converting Metabase Questions -> SQL"]},{"version":"v0.17.1","released":"2016-05-04T21:09:36.358Z","patch":true,"highlights":["Fix for Line chart ordering bug","Fix for Time granularity bugs"]},{"version":"v0.17.0","released":"2016-05-04T21:09:36.358Z","patch":false,"highlights":["Tags + Search for Saved Questions","Calculated columns","Faster Syncing of Metadata","Lots of database driver improvements and bug fixes"]},{"version":"v0.16.1","released":"2016-05-04T21:09:36.358Z","patch":true,"highlights":["Fixes for several time alignment issues (timezones)","Resolved problem with SQL Server db connections"]},{"version":"v0.16.0","released":"2016-05-04T21:09:36.358Z","patch":false,"highlights":["Fullscreen (and fabulous) Dashboards","Say hello to Metabot in Slack"]}]}
settings-last-updated	2022-09-28 18:15:00.22038+07
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
27	sync	1	2022-09-28 08:50:00.029326	2022-09-28 08:50:00.748214	718	\N
28	sync-timezone	1	2022-09-28 08:50:00.029539	2022-09-28 08:50:00.448566	419	{"timezone-id":"Asia/Jakarta"}
29	sync-tables	1	2022-09-28 08:50:00.448703	2022-09-28 08:50:00.472248	23	{"updated-tables":0,"total-tables":4}
30	sync-fields	1	2022-09-28 08:50:00.472351	2022-09-28 08:50:00.568974	96	{"total-fields":36,"updated-fields":0}
31	sync-fks	1	2022-09-28 08:50:00.569072	2022-09-28 08:50:00.589475	20	{"total-fks":3,"updated-fks":0,"total-failed":0}
32	sync-metabase-metadata	1	2022-09-28 08:50:00.589584	2022-09-28 08:50:00.748172	158	\N
33	analyze	1	2022-09-28 08:50:00.76092	2022-09-28 08:50:00.776849	15	\N
34	fingerprint-fields	1	2022-09-28 08:50:00.760946	2022-09-28 08:50:00.768716	7	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
35	classify-fields	1	2022-09-28 08:50:00.76881	2022-09-28 08:50:00.773686	4	{"fields-classified":0,"fields-failed":0}
36	classify-tables	1	2022-09-28 08:50:00.773746	2022-09-28 08:50:00.77678	3	{"total-tables":4,"tables-classified":0}
37	sync	2	2022-09-28 08:50:00.823966	2022-09-28 08:50:01.321292	497	\N
38	sync-timezone	2	2022-09-28 08:50:00.824013	2022-09-28 08:50:00.875524	51	{"timezone-id":"Asia/Jakarta"}
39	sync-tables	2	2022-09-28 08:50:00.875853	2022-09-28 08:50:00.903099	27	{"updated-tables":0,"total-tables":10}
40	sync-fields	2	2022-09-28 08:50:00.903184	2022-09-28 08:50:01.174781	271	{"total-fields":72,"updated-fields":0}
41	sync-fks	2	2022-09-28 08:50:01.174861	2022-09-28 08:50:01.302874	128	{"total-fks":0,"updated-fks":0,"total-failed":0}
42	sync-metabase-metadata	2	2022-09-28 08:50:01.302976	2022-09-28 08:50:01.321223	18	\N
43	analyze	2	2022-09-28 08:50:01.336685	2022-09-28 08:50:01.424476	87	\N
44	fingerprint-fields	2	2022-09-28 08:50:01.336713	2022-09-28 08:50:01.403603	66	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
45	classify-fields	2	2022-09-28 08:50:01.403707	2022-09-28 08:50:01.414291	10	{"fields-classified":0,"fields-failed":0}
46	classify-tables	2	2022-09-28 08:50:01.414424	2022-09-28 08:50:01.424422	9	{"total-tables":10,"tables-classified":0}
47	send-pulses	\N	2022-09-28 09:00:00.015	2022-09-28 09:00:00.033	18	\N
48	task-history-cleanup	\N	2022-09-28 09:00:00.022	2022-09-28 09:00:00.027	5	\N
49	sync	1	2022-09-28 09:50:00.178195	2022-09-28 09:50:00.72415	545	\N
50	sync-timezone	1	2022-09-28 09:50:00.180176	2022-09-28 09:50:00.275376	95	{"timezone-id":"Asia/Jakarta"}
51	sync-tables	1	2022-09-28 09:50:00.275573	2022-09-28 09:50:00.314894	39	{"updated-tables":0,"total-tables":4}
52	sync-fields	1	2022-09-28 09:50:00.315077	2022-09-28 09:50:00.464408	149	{"total-fields":36,"updated-fields":0}
53	sync-fks	1	2022-09-28 09:50:00.464487	2022-09-28 09:50:00.533972	69	{"total-fks":3,"updated-fks":0,"total-failed":0}
54	sync-metabase-metadata	1	2022-09-28 09:50:00.534081	2022-09-28 09:50:00.724084	190	\N
55	analyze	1	2022-09-28 09:50:00.755627	2022-09-28 09:50:00.788113	32	\N
56	fingerprint-fields	1	2022-09-28 09:50:00.755657	2022-09-28 09:50:00.774057	18	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
57	classify-fields	1	2022-09-28 09:50:00.774148	2022-09-28 09:50:00.780554	6	{"fields-classified":0,"fields-failed":0}
58	classify-tables	1	2022-09-28 09:50:00.780673	2022-09-28 09:50:00.788032	7	{"total-tables":4,"tables-classified":0}
59	sync	2	2022-09-28 09:50:00.842769	2022-09-28 09:50:01.619354	776	\N
60	sync-timezone	2	2022-09-28 09:50:00.842812	2022-09-28 09:50:00.919728	76	{"timezone-id":"Asia/Jakarta"}
61	sync-tables	2	2022-09-28 09:50:00.919793	2022-09-28 09:50:00.947972	28	{"updated-tables":0,"total-tables":10}
62	sync-fields	2	2022-09-28 09:50:00.948081	2022-09-28 09:50:01.473939	525	{"total-fields":72,"updated-fields":0}
63	sync-fks	2	2022-09-28 09:50:01.474028	2022-09-28 09:50:01.603778	129	{"total-fks":0,"updated-fks":0,"total-failed":0}
64	sync-metabase-metadata	2	2022-09-28 09:50:01.603865	2022-09-28 09:50:01.619283	15	\N
65	analyze	2	2022-09-28 09:50:01.653305	2022-09-28 09:50:01.802256	148	\N
66	fingerprint-fields	2	2022-09-28 09:50:01.653361	2022-09-28 09:50:01.771248	117	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
67	classify-fields	2	2022-09-28 09:50:01.771351	2022-09-28 09:50:01.785336	13	{"fields-classified":0,"fields-failed":0}
68	classify-tables	2	2022-09-28 09:50:01.785417	2022-09-28 09:50:01.802183	16	{"total-tables":10,"tables-classified":0}
70	task-history-cleanup	\N	2022-09-28 17:44:12.869	2022-09-28 17:44:12.88	11	\N
69	send-pulses	\N	2022-09-28 17:44:12.836	2022-09-28 17:44:12.869	33	\N
71	sync	1	2022-09-28 17:50:00.164441	2022-09-28 17:50:01.24645	1082	\N
72	sync-timezone	1	2022-09-28 17:50:00.166845	2022-09-28 17:50:00.819624	652	{"timezone-id":"Asia/Jakarta"}
73	sync-tables	1	2022-09-28 17:50:00.82065	2022-09-28 17:50:00.889053	68	{"updated-tables":0,"total-tables":4}
74	sync-fields	1	2022-09-28 17:50:00.88924	2022-09-28 17:50:00.998793	109	{"total-fields":36,"updated-fields":0}
75	sync-fks	1	2022-09-28 17:50:00.998919	2022-09-28 17:50:01.036571	37	{"total-fks":3,"updated-fks":0,"total-failed":0}
76	sync-metabase-metadata	1	2022-09-28 17:50:01.036726	2022-09-28 17:50:01.246378	209	\N
77	analyze	1	2022-09-28 17:50:01.309374	2022-09-28 17:50:01.37665	67	\N
78	fingerprint-fields	1	2022-09-28 17:50:01.309432	2022-09-28 17:50:01.342803	33	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
79	classify-fields	1	2022-09-28 17:50:01.342918	2022-09-28 17:50:01.357793	14	{"fields-classified":0,"fields-failed":0}
80	classify-tables	1	2022-09-28 17:50:01.357925	2022-09-28 17:50:01.376498	18	{"total-tables":4,"tables-classified":0}
81	sync	2	2022-09-28 17:50:01.446112	2022-09-28 17:50:02.6361	1189	\N
82	sync-timezone	2	2022-09-28 17:50:01.446167	2022-09-28 17:50:01.767553	321	{"timezone-id":"Asia/Jakarta"}
83	sync-tables	2	2022-09-28 17:50:01.7678	2022-09-28 17:50:01.838568	70	{"updated-tables":0,"total-tables":10}
84	sync-fields	2	2022-09-28 17:50:01.838672	2022-09-28 17:50:02.421697	583	{"total-fields":72,"updated-fields":0}
85	sync-fks	2	2022-09-28 17:50:02.421785	2022-09-28 17:50:02.586671	164	{"total-fks":0,"updated-fks":0,"total-failed":0}
86	sync-metabase-metadata	2	2022-09-28 17:50:02.587261	2022-09-28 17:50:02.635939	48	\N
87	analyze	2	2022-09-28 17:50:02.667014	2022-09-28 17:50:03.582746	915	\N
88	fingerprint-fields	2	2022-09-28 17:50:02.667057	2022-09-28 17:50:03.515937	848	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
89	classify-fields	2	2022-09-28 17:50:03.516204	2022-09-28 17:50:03.544938	28	{"fields-classified":0,"fields-failed":0}
90	classify-tables	2	2022-09-28 17:50:03.545124	2022-09-28 17:50:03.582657	37	{"total-tables":10,"tables-classified":0}
91	send-pulses	\N	2022-09-28 18:00:00.01	2022-09-28 18:00:00.018	8	\N
92	task-history-cleanup	\N	2022-09-28 18:00:00.02	2022-09-28 18:00:00.03	10	\N
93	send-pulses	\N	2022-09-28 19:10:38.622	2022-09-28 19:10:38.664	42	\N
94	task-history-cleanup	\N	2022-09-28 19:10:38.644	2022-09-28 19:10:38.654	10	\N
95	sync	2	2022-09-28 19:50:00.081103	2022-09-28 19:50:00.981891	900	\N
96	sync-timezone	2	2022-09-28 19:50:00.083539	2022-09-28 19:50:00.380121	296	{"timezone-id":"Asia/Jakarta"}
97	sync-tables	2	2022-09-28 19:50:00.380831	2022-09-28 19:50:00.428325	47	{"updated-tables":0,"total-tables":10}
98	sync-fields	2	2022-09-28 19:50:00.42851	2022-09-28 19:50:00.850166	421	{"total-fields":72,"updated-fields":0}
99	sync-fks	2	2022-09-28 19:50:00.850263	2022-09-28 19:50:00.964291	114	{"total-fks":0,"updated-fks":0,"total-failed":0}
100	sync-metabase-metadata	2	2022-09-28 19:50:00.964474	2022-09-28 19:50:00.981808	17	\N
101	analyze	2	2022-09-28 19:50:01.054253	2022-09-28 19:50:01.779176	724	\N
102	fingerprint-fields	2	2022-09-28 19:50:01.054287	2022-09-28 19:50:01.748063	693	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
103	classify-fields	2	2022-09-28 19:50:01.748128	2022-09-28 19:50:01.760707	12	{"fields-classified":0,"fields-failed":0}
104	classify-tables	2	2022-09-28 19:50:01.760793	2022-09-28 19:50:01.779108	18	{"total-tables":10,"tables-classified":0}
105	sync	1	2022-09-28 19:50:01.815102	2022-09-28 19:50:02.490905	675	\N
106	sync-timezone	1	2022-09-28 19:50:01.81516	2022-09-28 19:50:02.184376	369	{"timezone-id":"Asia/Jakarta"}
107	sync-tables	1	2022-09-28 19:50:02.184507	2022-09-28 19:50:02.215965	31	{"updated-tables":0,"total-tables":4}
108	sync-fields	1	2022-09-28 19:50:02.21609	2022-09-28 19:50:02.307474	91	{"total-fields":36,"updated-fields":0}
109	sync-fks	1	2022-09-28 19:50:02.307564	2022-09-28 19:50:02.325075	17	{"total-fks":3,"updated-fks":0,"total-failed":0}
110	sync-metabase-metadata	1	2022-09-28 19:50:02.325168	2022-09-28 19:50:02.490759	165	\N
111	analyze	1	2022-09-28 19:50:02.537428	2022-09-28 19:50:02.571647	34	\N
112	fingerprint-fields	1	2022-09-28 19:50:02.537475	2022-09-28 19:50:02.554857	17	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
113	classify-fields	1	2022-09-28 19:50:02.554974	2022-09-28 19:50:02.565573	10	{"fields-classified":0,"fields-failed":0}
114	classify-tables	1	2022-09-28 19:50:02.565668	2022-09-28 19:50:02.57156	5	{"total-tables":4,"tables-classified":0}
115	send-pulses	\N	2022-09-28 20:00:00.009	2022-09-28 20:00:00.019	10	\N
116	task-history-cleanup	\N	2022-09-28 20:00:00.019	2022-09-28 20:00:00.02	1	\N
117	sync	2	2022-09-28 20:50:00.034618	2022-09-28 20:50:00.874793	840	\N
118	sync-timezone	2	2022-09-28 20:50:00.034733	2022-09-28 20:50:00.097761	63	{"timezone-id":"Asia/Jakarta"}
119	sync-tables	2	2022-09-28 20:50:00.09784	2022-09-28 20:50:00.171798	73	{"updated-tables":3,"total-tables":10}
120	sync-fields	2	2022-09-28 20:50:00.171861	2022-09-28 20:50:00.706549	534	{"total-fields":87,"updated-fields":15}
121	sync-fks	2	2022-09-28 20:50:00.70668	2022-09-28 20:50:00.861099	154	{"total-fks":0,"updated-fks":0,"total-failed":0}
122	sync-metabase-metadata	2	2022-09-28 20:50:00.861235	2022-09-28 20:50:00.874703	13	\N
123	analyze	2	2022-09-28 20:50:00.89083	2022-09-28 20:50:01.359357	468	\N
124	fingerprint-fields	2	2022-09-28 20:50:00.890855	2022-09-28 20:50:01.133626	242	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":15,"fingerprints-attempted":27}
125	classify-fields	2	2022-09-28 20:50:01.133699	2022-09-28 20:50:01.338289	204	{"fields-classified":15,"fields-failed":0}
126	classify-tables	2	2022-09-28 20:50:01.33836	2022-09-28 20:50:01.359288	20	{"total-tables":13,"tables-classified":3}
127	sync	1	2022-09-28 20:50:01.395594	2022-09-28 20:50:01.631933	236	\N
128	sync-timezone	1	2022-09-28 20:50:01.395628	2022-09-28 20:50:01.404646	9	{"timezone-id":"Asia/Jakarta"}
129	sync-tables	1	2022-09-28 20:50:01.404729	2022-09-28 20:50:01.418133	13	{"updated-tables":0,"total-tables":4}
130	sync-fields	1	2022-09-28 20:50:01.418255	2022-09-28 20:50:01.492441	74	{"total-fields":36,"updated-fields":0}
131	sync-fks	1	2022-09-28 20:50:01.492512	2022-09-28 20:50:01.504185	11	{"total-fks":3,"updated-fks":0,"total-failed":0}
132	sync-metabase-metadata	1	2022-09-28 20:50:01.504263	2022-09-28 20:50:01.631867	127	\N
133	analyze	1	2022-09-28 20:50:01.64384	2022-09-28 20:50:01.656368	12	\N
134	fingerprint-fields	1	2022-09-28 20:50:01.643859	2022-09-28 20:50:01.650234	6	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
135	classify-fields	1	2022-09-28 20:50:01.650274	2022-09-28 20:50:01.653787	3	{"fields-classified":0,"fields-failed":0}
136	classify-tables	1	2022-09-28 20:50:01.653842	2022-09-28 20:50:01.656321	2	{"total-tables":4,"tables-classified":0}
137	send-pulses	\N	2022-09-28 21:00:00.018	2022-09-28 21:00:00.037	19	\N
138	task-history-cleanup	\N	2022-09-28 21:00:00.028	2022-09-28 21:00:00.041	13	\N
139	sync	2	2022-09-28 21:50:00.081078	2022-09-28 21:50:01.102072	1020	\N
140	sync-timezone	2	2022-09-28 21:50:00.083006	2022-09-28 21:50:00.418189	335	{"timezone-id":"Asia/Jakarta"}
141	sync-tables	2	2022-09-28 21:50:00.419049	2022-09-28 21:50:00.50862	89	{"updated-tables":0,"total-tables":13}
142	sync-fields	2	2022-09-28 21:50:00.5088	2022-09-28 21:50:00.941279	432	{"total-fields":87,"updated-fields":0}
143	sync-fks	2	2022-09-28 21:50:00.941356	2022-09-28 21:50:01.084262	142	{"total-fks":0,"updated-fks":0,"total-failed":0}
144	sync-metabase-metadata	2	2022-09-28 21:50:01.084398	2022-09-28 21:50:01.102014	17	\N
145	analyze	2	2022-09-28 21:50:01.174449	2022-09-28 21:50:01.926091	751	\N
146	fingerprint-fields	2	2022-09-28 21:50:01.174498	2022-09-28 21:50:01.884454	709	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
147	classify-fields	2	2022-09-28 21:50:01.884753	2022-09-28 21:50:01.902283	17	{"fields-classified":0,"fields-failed":0}
148	classify-tables	2	2022-09-28 21:50:01.902358	2022-09-28 21:50:01.926035	23	{"total-tables":13,"tables-classified":0}
149	sync	1	2022-09-28 21:50:01.964241	2022-09-28 21:50:02.634277	670	\N
150	sync-timezone	1	2022-09-28 21:50:01.964289	2022-09-28 21:50:02.342976	378	{"timezone-id":"Asia/Jakarta"}
151	sync-tables	1	2022-09-28 21:50:02.343072	2022-09-28 21:50:02.379496	36	{"updated-tables":0,"total-tables":4}
152	sync-fields	1	2022-09-28 21:50:02.379597	2022-09-28 21:50:02.452109	72	{"total-fields":36,"updated-fields":0}
153	sync-fks	1	2022-09-28 21:50:02.452195	2022-09-28 21:50:02.480574	28	{"total-fks":3,"updated-fks":0,"total-failed":0}
154	sync-metabase-metadata	1	2022-09-28 21:50:02.480665	2022-09-28 21:50:02.6342	153	\N
155	analyze	1	2022-09-28 21:50:02.650741	2022-09-28 21:50:02.674756	24	\N
156	fingerprint-fields	1	2022-09-28 21:50:02.650783	2022-09-28 21:50:02.666479	15	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
157	classify-fields	1	2022-09-28 21:50:02.666565	2022-09-28 21:50:02.671372	4	{"fields-classified":0,"fields-failed":0}
158	classify-tables	1	2022-09-28 21:50:02.671447	2022-09-28 21:50:02.674705	3	{"total-tables":4,"tables-classified":0}
159	send-pulses	\N	2022-09-28 22:00:00.01	2022-09-28 22:00:00.033	23	\N
160	task-history-cleanup	\N	2022-09-28 22:00:00.043	2022-09-28 22:00:00.047	4	\N
161	sync	2	2022-09-28 22:50:00.052667	2022-09-28 22:50:00.6866	633	\N
162	sync-timezone	2	2022-09-28 22:50:00.053006	2022-09-28 22:50:00.132998	79	{"timezone-id":"Asia/Jakarta"}
163	sync-tables	2	2022-09-28 22:50:00.133109	2022-09-28 22:50:00.155858	22	{"updated-tables":0,"total-tables":13}
164	sync-fields	2	2022-09-28 22:50:00.155955	2022-09-28 22:50:00.520892	364	{"total-fields":87,"updated-fields":0}
165	sync-fks	2	2022-09-28 22:50:00.520981	2022-09-28 22:50:00.665929	144	{"total-fks":0,"updated-fks":0,"total-failed":0}
166	sync-metabase-metadata	2	2022-09-28 22:50:00.666067	2022-09-28 22:50:00.686525	20	\N
167	analyze	2	2022-09-28 22:50:00.713158	2022-09-28 22:50:00.928118	214	\N
168	fingerprint-fields	2	2022-09-28 22:50:00.713205	2022-09-28 22:50:00.853691	140	{"no-data-fingerprints":12,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":12}
169	classify-fields	2	2022-09-28 22:50:00.853801	2022-09-28 22:50:00.899386	45	{"fields-classified":0,"fields-failed":0}
170	classify-tables	2	2022-09-28 22:50:00.899489	2022-09-28 22:50:00.927968	28	{"total-tables":13,"tables-classified":0}
171	sync	1	2022-09-28 22:50:00.968096	2022-09-28 22:50:01.316185	348	\N
172	sync-timezone	1	2022-09-28 22:50:00.968147	2022-09-28 22:50:00.982768	14	{"timezone-id":"Asia/Jakarta"}
173	sync-tables	1	2022-09-28 22:50:00.982848	2022-09-28 22:50:00.995926	13	{"updated-tables":0,"total-tables":4}
174	sync-fields	1	2022-09-28 22:50:00.996014	2022-09-28 22:50:01.053844	57	{"total-fields":36,"updated-fields":0}
175	sync-fks	1	2022-09-28 22:50:01.05392	2022-09-28 22:50:01.068391	14	{"total-fks":3,"updated-fks":0,"total-failed":0}
176	sync-metabase-metadata	1	2022-09-28 22:50:01.068472	2022-09-28 22:50:01.316116	247	\N
177	analyze	1	2022-09-28 22:50:01.330318	2022-09-28 22:50:01.346457	16	\N
178	fingerprint-fields	1	2022-09-28 22:50:01.330358	2022-09-28 22:50:01.339164	8	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
179	classify-fields	1	2022-09-28 22:50:01.339221	2022-09-28 22:50:01.343164	3	{"fields-classified":0,"fields-failed":0}
180	classify-tables	1	2022-09-28 22:50:01.343226	2022-09-28 22:50:01.346403	3	{"total-tables":4,"tables-classified":0}
\.


--
-- Data for Name: view_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_log (id, user_id, model, model_id, "timestamp") FROM stdin;
1	1	card	1	2022-09-28 15:57:16.27131+00
2	1	dashboard	1	2022-09-28 15:57:48.526289+00
3	1	dashboard	1	2022-09-28 15:57:55.298074+00
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_id_seq', 5, true);


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

SELECT pg_catalog.setval('public.metabase_field_id_seq', 123, true);


--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_fieldvalues_id_seq', 38, true);


--
-- Name: metabase_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_table_id_seq', 17, true);


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

SELECT pg_catalog.setval('public.query_execution_id_seq', 16, true);


--
-- Name: report_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_card_id_seq', 1, true);


--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_cardfavorite_id_seq', 1, false);


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboard_id_seq', 1, true);


--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboardcard_id_seq', 1, true);


--
-- Name: revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revision_id_seq', 5, true);


--
-- Name: segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.segment_id_seq', 1, false);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_history_id_seq', 180, true);


--
-- Name: view_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.view_log_id_seq', 3, true);


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

