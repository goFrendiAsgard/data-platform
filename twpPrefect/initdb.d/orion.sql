--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: state_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.state_type AS ENUM (
    'SCHEDULED',
    'PENDING',
    'RUNNING',
    'COMPLETED',
    'FAILED',
    'CANCELLED',
    'CRASHED'
);


ALTER TYPE public.state_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    last_activity_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    work_queue_id uuid NOT NULL
);


ALTER TABLE public.agent OWNER TO postgres;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: block_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_document (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    block_schema_id uuid NOT NULL,
    block_type_id uuid NOT NULL,
    is_anonymous boolean DEFAULT false NOT NULL
);


ALTER TABLE public.block_document OWNER TO postgres;

--
-- Name: block_document_reference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_document_reference (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    parent_block_document_id uuid NOT NULL,
    reference_block_document_id uuid NOT NULL
);


ALTER TABLE public.block_document_reference OWNER TO postgres;

--
-- Name: block_schema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_schema (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fields jsonb DEFAULT '{}'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    block_type_id uuid NOT NULL,
    capabilities jsonb DEFAULT '[]'::jsonb NOT NULL,
    version character varying DEFAULT 'non-versioned'::character varying NOT NULL
);


ALTER TABLE public.block_schema OWNER TO postgres;

--
-- Name: block_schema_reference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_schema_reference (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    parent_block_schema_id uuid NOT NULL,
    reference_block_schema_id uuid NOT NULL
);


ALTER TABLE public.block_schema_reference OWNER TO postgres;

--
-- Name: block_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block_type (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    logo_url character varying,
    documentation_url character varying,
    description character varying,
    code_example character varying,
    is_protected boolean DEFAULT false NOT NULL,
    slug character varying NOT NULL
);


ALTER TABLE public.block_type OWNER TO postgres;

--
-- Name: concurrency_limit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.concurrency_limit (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tag character varying NOT NULL,
    concurrency_limit integer NOT NULL,
    active_slots jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.concurrency_limit OWNER TO postgres;

--
-- Name: configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuration (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    key character varying NOT NULL,
    value jsonb NOT NULL
);


ALTER TABLE public.configuration OWNER TO postgres;

--
-- Name: deployment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deployment (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    schedule jsonb,
    is_schedule_active boolean DEFAULT true NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    flow_data jsonb,
    flow_id uuid NOT NULL,
    infrastructure_document_id uuid,
    description text,
    manifest_path character varying,
    parameter_openapi_schema jsonb,
    storage_document_id uuid,
    version character varying,
    infra_overrides jsonb DEFAULT '{}'::jsonb NOT NULL,
    path character varying,
    entrypoint character varying,
    work_queue_name character varying
);


ALTER TABLE public.deployment OWNER TO postgres;

--
-- Name: flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.flow OWNER TO postgres;

--
-- Name: flow_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow_run (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    state_type public.state_type,
    run_count integer DEFAULT 0 NOT NULL,
    expected_start_time timestamp with time zone,
    next_scheduled_start_time timestamp with time zone,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    total_run_time interval DEFAULT '00:00:00'::interval NOT NULL,
    flow_version character varying,
    parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    idempotency_key character varying,
    context jsonb DEFAULT '{}'::jsonb NOT NULL,
    empirical_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    auto_scheduled boolean DEFAULT false NOT NULL,
    flow_id uuid NOT NULL,
    deployment_id uuid,
    parent_task_run_id uuid,
    state_id uuid,
    state_name character varying,
    infrastructure_document_id uuid,
    work_queue_name character varying
);


ALTER TABLE public.flow_run OWNER TO postgres;

--
-- Name: flow_run_notification_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow_run_notification_policy (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    state_names jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    message_template character varying,
    block_document_id uuid NOT NULL
);


ALTER TABLE public.flow_run_notification_policy OWNER TO postgres;

--
-- Name: flow_run_notification_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow_run_notification_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    flow_run_notification_policy_id uuid NOT NULL,
    flow_run_state_id uuid NOT NULL
);


ALTER TABLE public.flow_run_notification_queue OWNER TO postgres;

--
-- Name: flow_run_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow_run_state (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type public.state_type NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    message character varying,
    state_details jsonb DEFAULT '{}'::jsonb NOT NULL,
    data jsonb,
    flow_run_id uuid NOT NULL
);


ALTER TABLE public.flow_run_state OWNER TO postgres;

--
-- Name: log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    level smallint NOT NULL,
    flow_run_id uuid NOT NULL,
    task_run_id uuid,
    message text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.log OWNER TO postgres;

--
-- Name: saved_search; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_search (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    filters jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.saved_search OWNER TO postgres;

--
-- Name: task_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_run (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    state_type public.state_type,
    run_count integer DEFAULT 0 NOT NULL,
    expected_start_time timestamp with time zone,
    next_scheduled_start_time timestamp with time zone,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    total_run_time interval DEFAULT '00:00:00'::interval NOT NULL,
    task_key character varying NOT NULL,
    dynamic_key character varying NOT NULL,
    cache_key character varying,
    cache_expiration timestamp with time zone,
    task_version character varying,
    empirical_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    task_inputs jsonb DEFAULT '{}'::jsonb NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    flow_run_id uuid NOT NULL,
    state_id uuid,
    state_name character varying
);


ALTER TABLE public.task_run OWNER TO postgres;

--
-- Name: task_run_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_run_state (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type public.state_type NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    message character varying,
    state_details jsonb DEFAULT '{}'::jsonb NOT NULL,
    data jsonb,
    task_run_id uuid NOT NULL
);


ALTER TABLE public.task_run_state OWNER TO postgres;

--
-- Name: task_run_state_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_run_state_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cache_key character varying NOT NULL,
    cache_expiration timestamp with time zone,
    task_run_state_id uuid NOT NULL
);


ALTER TABLE public.task_run_state_cache OWNER TO postgres;

--
-- Name: work_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    filter jsonb,
    description character varying DEFAULT ''::character varying NOT NULL,
    is_paused boolean DEFAULT false NOT NULL,
    concurrency_limit integer
);


ALTER TABLE public.work_queue OWNER TO postgres;

--
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.agent (id, created, updated, name, last_activity_time, work_queue_id) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
2d5e000696f1
\.


--
-- Data for Name: block_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block_document (id, created, updated, name, data, block_schema_id, block_type_id, is_anonymous) FROM stdin;
6ddce959-9949-4f35-afa9-51e9518b42bd	2022-09-28 01:53:24.359826+00	2022-09-28 01:53:24.359841+00	airbyte-mysql-postgre-connection-id	"gAAAAABjM6kUeIMnlQRMxms3xSJ0YdyTe-NRJHdlAMfOyGOPOy7RTA5dtHukGV8CgXjM4OQ7IOv0CiCZrMputCG-BGuttJGAMHYqij8g2uvz7yimT7JcDceA4IiBdBTS7PI7XpfRnkrctzxQcSAR4S9jBzmjTviaQg=="	f8070056-648a-45d6-a02a-1e56f57c8b1a	e7d3bbd3-06b8-40ff-969b-c7a236ca9961	f
6e8afe07-28d1-4e98-a930-c3074e5775ae	2022-09-28 02:08:27.901482+00	2022-09-28 02:08:27.901495+00	anonymous-268d6203-fad5-4a8b-95ba-dbba12c342a8	"gAAAAABjM6ybr7XBIaXuuj2gNqfiKSOSJ0BffEDnkQSQw1bkcZxVP3IP4zhMPu5O_MPiLtvVuHFvyAgV8uk2GS60C6R-D-PXrx3-V08NsQPAhqD_Px9Is30WOj1uOIXi5kof4wjHR0_Zwekobr-8DVcmXGle4UYJNe5oUnZsAyYn7pmKoATs2GFQjzQUBImJsrQg2Q4IQj6GNGXhGekqqO20H6K0hzwlhgow7oY6nS4yzr54cwn6Vd3FVSmcSlLVYFiASV0od-gy"	f0421dff-a3d0-4459-a323-db876ad82401	b73f6525-cee3-402f-ba3e-af01ed383be9	t
a2867581-901a-4677-91e2-ad1644f805ad	2022-09-28 02:11:54.785257+00	2022-09-28 02:11:54.785303+00	anonymous-ad15fe76-5656-4ea4-9024-6b0869a774e4	"gAAAAABjM61qDQVvJPtRS-eeJmKW6WlmLpQuzkdViPep--13zFxYxiWvM2_ALqEnG31zKbTX_dFCCUNIXT2SenhIa3pW7B3soU8nKD2CFbORJRE7YvV56idTe79vcFEE89LpdMikSTPG"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
6a2f19a1-48ca-4d5e-b339-99caaeceddc3	2022-09-28 02:20:21.885464+00	2022-09-28 02:20:21.885477+00	anonymous-c315530e-c6ce-4bde-b33a-dabec241097b	"gAAAAABjM69lu0FhnaVqJJy5hgpdKCIS5wATjESKqMbRJ_3DD71o0Hax7e0OfCWRzeZTAwe794j-iAVNPzQNrsMCfSXGBoj8sRuN5rNW4TRVfqgGbH89abKNf-XSaLQmqNy6HpIBxPD1"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
ea659451-1bda-40bb-9525-ded0167cc4d5	2022-09-28 02:22:57.280106+00	2022-09-28 02:22:57.280121+00	anonymous-b30f3eb3-5b37-4520-b3e3-71a7c029f719	"gAAAAABjM7ABrVL760afRACuD3aJ6Wb5B1kTytz4UVUiOUkX9zyl9K3bLYaCPMCwk9d8uT79r6eOne3BKypo_QK2RtHFbHvAsP3mXD-9H8r1LMEbDlZVbsMS60759prs-gh4ZFZZdxQV"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
c298efa5-a65a-4160-b049-d00946e1ed3f	2022-09-28 02:27:02.406397+00	2022-09-28 02:27:02.406409+00	anonymous-8e43c3ec-22b4-482a-8d14-327b222439d6	"gAAAAABjM7D2JKx8hr1beWtcaqs3As14U0YzdC8BAnFDvbXZ8ReHDvH393Xr0wm5iTsOgj1Myzpy0eBlY45uwGZHXCwZAtyI4i3NW29JXjY0M_s1RJFZZMcRStx4Sj2NlMoltfErDHq9"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
a09d06ec-f077-4e66-ab75-f1d3f2d2aec7	2022-09-28 02:30:33.794509+00	2022-09-28 02:30:33.794524+00	anonymous-9e638fe8-72a2-46d7-9def-0b5f969312ac	"gAAAAABjM7HJK8nIdeiuNGGraDN-pivbXXjNtL3egU2Oy0gHkh3ZYumk7Ri5H0OltlLE1RIMYPMpqfNtG3YjnSy8rNhXspxfOCSqBgdU27GyvJUGBFoWsz0e8Q7HTlw4TP2gOqXyYCFr"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
51c2af35-517a-4b9c-840f-7d2a55476a65	2022-09-28 12:31:35.047929+00	2022-09-28 12:31:35.04794+00	anonymous-731f43c2-d5b4-4d4f-a384-8edb0befda17	"gAAAAABjND6nztVOVRTZonxt4r8A8fMYn6by6j3tVFI9-j5ASyC3rr7SwwV70Zn7kE-ImSrhj9tVAJ3ckafem6QMdBQ-HIZlcmP5XTXVX6r3str5Uk4cKc4ZdMysGzo8BkF0lKi6hUHW"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
3dce303d-be53-4af2-85c2-61fdc82175e7	2022-09-28 12:33:15.225166+00	2022-09-28 12:33:15.225177+00	anonymous-ce4434b0-4eb5-4413-bc74-453b339ee022	"gAAAAABjND8LVPM0MKfhaXI25LuhTDYGUqxEa4NHcM6Sgpkdo4Y-0wjx-r2eigtHSYPKfxUNVhpHW0XmP8po_jmUrhUX4tT9qshU3BvfSwYFuSuidUAHfSYQmXnlTFjExYqWkU6DeBF5"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
019b0990-5aaf-408f-82ce-9e318f212918	2022-09-28 12:35:05.517226+00	2022-09-28 12:35:05.517264+00	anonymous-013be3a9-90b0-4e20-b35a-9d418bc3d181	"gAAAAABjND95SK0VTxu4koN8wE7aqnKNodagds4tlY0D4Q_IhbQ2Ve3vNjdagnnk2kykzOtIcG_464aZY_RoaqH76vXoInGOXNZgYEkRu4_XHM6f0YAgFTxFKxEKtcTcdyRMxY0HhpJa"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
94380e94-108a-40fc-9c1f-204e3475e890	2022-09-28 14:50:15.90386+00	2022-09-28 14:50:15.903873+00	anonymous-c6fda917-5e29-4a36-aba2-a1cd7f8fd0f9	"gAAAAABjNF8nxE-SxFcQntjBkEdZTPUjgZh8BC8L0xfxgA711H-cFdOhGfpmDi8TjgEx8brN5T5HEK2KlMzdGxACKwiLTl989QuKiohNS4jaCMUKqL1JEh394XLVP1Y4LLtOezZbrBL0"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
c37a0458-40b6-455e-8d6f-74dadace40d7	2022-09-28 14:51:56.143358+00	2022-09-28 14:51:56.143371+00	anonymous-54f7b9ca-ea7c-42d9-b52a-20dec7f72ed2	"gAAAAABjNF-MJ5Mg3mTPGIbaXMG1TbiJX-YXSSrzolsdAGek_bbyrz1zPLAMayGus__fleco7SBvu8pkDL_arkmXySooaa-5IKAtMrg92b8LGTbfvNyXMPE-9tLA8w4AjrnqWnPvccVG"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
42ca9a9b-e3a6-493f-a1f6-f61973a5a475	2022-09-28 14:58:06.983777+00	2022-09-28 14:58:06.983793+00	anonymous-a0d18a72-856a-4331-b08f-28ee2ffa58ac	"gAAAAABjNGD-kFB8AvyilWNXxjOepinQuRpaX0wmvURmKfjW2zPbTTcqj6X8iF9Y4Yxj8t2NHuBK4Ofq6zdLWc4qXtNFdrT8ti0Mh0OlMU6p1BorVs2i3d2W_SzAvKCHeVH8G2R7P-ee"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
c41d76fb-ef0e-4840-acc0-d0cd874bc239	2022-09-28 15:01:07.645722+00	2022-09-28 15:01:07.645738+00	anonymous-6d6d9943-e1fc-4e43-880e-afe0e62d2fc6	"gAAAAABjNGGz3r6dBeKQsqXnvZFMlkZoeNboe-Icx-Cpiz7XZ358QanY9vwgRJ5jGJFps5u-49PzAsmRKxo1Cv9RGSNOg0BBsDdpLv7Qcm2ha_r3csDA_fyya4eCb5w9Bv5aoqUxbUP1"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
bfc399ae-30da-48da-bd51-3a5996fa36a8	2022-09-28 15:14:34.916525+00	2022-09-28 15:14:34.916556+00	anonymous-34055efc-7b06-4f10-9708-af65bc2fa695	"gAAAAABjNGTalUJ9seOj2J-40B-Vl7_QKZKCyxn5QHrdRqT0Zmmlf3x4SD6xBW7Y7laPo3-VxpyORxlUqO_Sy-D0FYo0TMSMABw--Lm871LDgLd4hkNJEBzmXr1t_JAcv4ePK1hXdmb5"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
1216d549-be43-479a-b945-7f55880b3a32	2022-09-28 15:22:36.444203+00	2022-09-28 15:22:36.444217+00	anonymous-f8e17785-bd34-4d61-ab40-7205f3525c66	"gAAAAABjNGa8BxdaVpRrd7ulZQ45Wjo42z-4LY3XDFQDusbJwcqyRIReE9IuSAU6XR8Y-1FZeFfNujzs8klh1BRH7X_w4qfE4_QwDYp-d-3vXK-wsWesAmU0mbE1AQA6dnb1oPO0B_ge"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
a9cd1d25-9b83-4da1-babc-e836be923e66	2022-09-28 15:26:07.258882+00	2022-09-28 15:26:07.258895+00	anonymous-7965e2ac-73f9-47e2-a350-25797040c17d	"gAAAAABjNGePwVpLe-9KG6KA5645HBBlOLgCEKeghJIZHbUtMVR7U-0aui9SapJQU0W5LMl78BsrUDFW_0btKOkrWtMfZCxQbKjAtIZuuLUFvII_DbEBaV1n8G3B-hUJI1WIHnK1aXMU"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
c068f2b9-95c7-410c-91ae-9ebc242a6c8c	2022-09-28 15:29:32.919748+00	2022-09-28 15:29:32.91976+00	anonymous-85cb4439-623f-4e24-92f3-6dc545cc838b	"gAAAAABjNGhcCn3ePTzpz0Z_aZo4wNJ9iWVsYnaFYmDZyw89eYmZkB68L_hE0_stqG6dePtXBkmsDi8c_C2fFkurVWhhTJi4A0Rk1enAeCZpnfHrPL4DsAg_BwDudGC9SJmu3JmiYRVB"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
9fc9faf2-7bb3-4ffb-97bd-5bb0f3e5bc48	2022-09-28 15:38:29.223777+00	2022-09-28 15:38:29.223809+00	anonymous-d4dd7ac6-597c-49db-84a3-76ba8dca1a7b	"gAAAAABjNGp1gaczcoZ4IN404HqneAKx4KISNXv3ALzWc-ZQTe_RlWGt2NjldUowyUafzJDt1NJtetjH42cVrmIG4yX66TsIKhS-O9XheWRkFWaXIX76JfDFTkrgT8lSaIJpGSgDzYuD"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
30f63816-d3ab-4f41-b466-184f39f1431f	2022-09-28 14:26:42.793822+00	2022-09-28 15:39:45.939709+00	postgres-connection	"gAAAAABjNGrBpHhqU2R0gYkMvhElO6j-wuT_6kwRjIGzrXDSPkWSNxh5mEH8eBF1eDmsSrCbIJY5KeLgrJww3JS2QosiWNZaHuE-8F7-uYCTVPvxEVV2JJY--eg4ASYz-YN6ldNfzKzaj3zqAgbwuGAQOMgN35CwzsJ9Bpg-sZbroygqO8vk3jddmzoOZIV9RU6nFzOXXTOtO4w0w3Qov2akN16PIMyBVDuIDeIk4MvauQUfokpNHv2OQjNBlRv43AlEpuHnqj3v80YomOPZ4xJQ3XUUUo2B1OBTRgWBSX5qZWaTGAFuj4A="	2ccb6f57-fbae-4a2a-9ecd-3f5f5638163f	3992f61d-0a7e-47f1-a450-75a1ed5473f2	f
6ae8d8f4-5022-4e8f-a358-47564570a70e	2022-09-28 15:40:14.67427+00	2022-09-28 15:40:14.674286+00	anonymous-dae91952-c9b8-4843-bb9c-dab28a80a20e	"gAAAAABjNGreOE-H8shDQ4gygrbric6wpygzhPP3fnK1FdiLaHk0h7Y8RE8_ehuimW9r7Ha04dBWL4RjQEzZtMlrb1iQahnsENejTSZdGOGQft0xsE5c4SToGls_8bR0zxSBDe9iyid5"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
c3356fbf-7634-46f4-b6ec-0b0b8047ff80	2022-09-28 15:44:35.486277+00	2022-09-28 15:44:35.486294+00	anonymous-ea17d851-33f1-4869-9f2d-831a2000a2dd	"gAAAAABjNGvjACPcKyfV4pehxL0X0oLAdIMXiistU76O8q3n0neeRGEmE9Cr8kytfJmfQigYmIsAw6L6ZMKeUt7QWl_G-mQQq9YJVLR0B_dUhd1FT_WOtuMspigJ1ZBsjpxEvyKgRZK7"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
ab0be542-6ad7-47b8-8570-422c482b1daa	2022-09-28 15:48:27.344609+00	2022-09-28 15:48:27.344624+00	anonymous-58ac8913-9f4f-412e-b027-2f9c5e26cccf	"gAAAAABjNGzLvMyCHXoEf0ZV4_6FecVoQTMsP-f_x8cGDacjBkIDpYSNxHI8TxclAo42Y89iC3tSFxd725ix_WgR-kukAnXUV-R10pSL4iITwsnnY9jajxKWY6zgOsZE_hQZ1tshkpVS"	5ef7faf7-e862-4623-bc7e-6225ba99a073	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	t
\.


--
-- Data for Name: block_document_reference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block_document_reference (id, created, updated, name, parent_block_document_id, reference_block_document_id) FROM stdin;
\.


--
-- Data for Name: block_schema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block_schema (id, created, updated, fields, checksum, block_type_id, capabilities, version) FROM stdin;
257ba57e-efa8-423c-ba7c-430552381c71	2022-09-19 00:02:39.849616+00	2022-09-19 00:02:39.84963+00	{"type": "object", "title": "SlackWebhook", "required": ["url"], "properties": {"url": {"type": "string", "title": "Webhook URL", "format": "password", "example": "https://hooks.slack.com/XXX", "writeOnly": true, "description": "Slack incoming webhook URL used to send notifications."}}, "description": "Enables sending notifications via a provided Slack webhook.", "secret_fields": ["url"], "block_type_slug": "slack-webhook"}	sha256:a40a9a133af175bb9d013045a06d364f88dc26e0e46f764634cd855a940e771a	e789e69f-6a5a-492c-8ea2-fea2d289c282	["notify"]	2.3.1
2ccb6f57-fbae-4a2a-9ecd-3f5f5638163f	2022-09-19 00:02:39.86641+00	2022-09-19 00:02:39.86642+00	{"type": "object", "title": "JSON", "required": ["value"], "properties": {"value": {"title": "Value", "description": "A JSON-compatible value."}}, "description": "A block that represents JSON", "secret_fields": [], "block_type_slug": "json"}	sha256:ef9b76010e0545bd7f2212029460731f66ccfce289affe4b504cbeb702fc8ea3	3992f61d-0a7e-47f1-a450-75a1ed5473f2	[]	2.3.1
f8070056-648a-45d6-a02a-1e56f57c8b1a	2022-09-19 00:02:39.880782+00	2022-09-19 00:02:39.880798+00	{"type": "object", "title": "String", "required": ["value"], "properties": {"value": {"type": "string", "title": "Value", "description": "A string value."}}, "description": "A block that represents a string", "secret_fields": [], "block_type_slug": "string"}	sha256:e9f3f43e55b73bc94ee2a355f1e4ef7064645268cba22571c2a95d90a2af8dd0	e7d3bbd3-06b8-40ff-969b-c7a236ca9961	[]	2.3.1
200839ca-e949-4096-bf37-8c7c878eb985	2022-09-19 00:02:39.898274+00	2022-09-19 00:02:39.898287+00	{"type": "object", "title": "DateTime", "required": ["value"], "properties": {"value": {"type": "string", "title": "Value", "format": "date-time", "description": "An ISO 8601-compatible datetime value."}}, "description": "A block that represents a datetime", "secret_fields": [], "block_type_slug": "date-time"}	sha256:7943c88ca6ab22804082b595b9847d035a1364bdb23474c927317bcab9cb5d9c	dd995a8d-16ec-43ff-a6bb-9593da239594	[]	2.3.1
0dfbfece-b584-4cd6-88bd-4bb68ae270a6	2022-09-19 00:02:39.913972+00	2022-09-19 00:02:39.913985+00	{"type": "object", "title": "Secret", "required": ["value"], "properties": {"value": {"type": "string", "title": "Value", "format": "password", "writeOnly": true, "description": "A string value that should be kept secret."}}, "description": "A block that represents a secret value. The value stored in this block will be obfuscated when\\nthis block is logged or shown in the UI.", "secret_fields": ["value"], "block_type_slug": "secret"}	sha256:e6b26e0a0240eb112e604608338f863e5ca2f137936e310014bfa2139d0a9b6c	7d97f0e1-b7c2-4415-89f8-ae130dbe13cc	[]	2.3.1
5ef7faf7-e862-4623-bc7e-6225ba99a073	2022-09-19 00:02:39.927731+00	2022-09-19 00:02:39.92774+00	{"type": "object", "title": "LocalFileSystem", "properties": {"basepath": {"type": "string", "title": "Basepath", "description": "Default local path for this block to write to."}}, "description": "Store data as a file on a local file system.", "secret_fields": [], "block_type_slug": "local-file-system"}	sha256:6db1ab242e7b2b88a52dc137a7da3a373af63e0a103b9a91e060ed54a26f395a	65af4d14-7c33-47c5-aab7-31fcaa87a2a0	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
35363abb-3cb5-4b1c-b322-df6ce6049e1a	2022-09-19 00:02:39.941436+00	2022-09-19 00:02:39.941446+00	{"type": "object", "title": "RemoteFileSystem", "required": ["basepath"], "properties": {"basepath": {"type": "string", "title": "Basepath", "example": "s3://my-bucket/my-folder/", "description": "Default path for this block to write to."}, "settings": {"type": "object", "title": "Settings", "description": "Additional settings to pass through to fsspec."}}, "description": "Store data as a file on a remote file system.\\n\\nSupports any remote file system supported by `fsspec`. The file system is specified\\nusing a protocol. For example, \\"s3://my-bucket/my-folder/\\" will use S3.", "secret_fields": [], "block_type_slug": "remote-file-system"}	sha256:f6998c8723a78207471938f5f74d6d4815ff14c2900caf8e9c3b3ece47bfeb40	93d4c468-974a-4b18-851e-cb013c0ebe2b	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
6fc9b7f1-57c4-4311-8ee7-7fc38e175dfa	2022-09-19 00:02:39.954732+00	2022-09-19 00:02:39.954743+00	{"type": "object", "title": "S3", "required": ["bucket_path"], "properties": {"bucket_path": {"type": "string", "title": "Bucket Path", "example": "my-bucket/a-directory-within", "description": "An S3 bucket path."}, "aws_access_key_id": {"type": "string", "title": "AWS Access Key ID", "format": "password", "example": "AKIAIOSFODNN7EXAMPLE", "writeOnly": true, "description": "Equivalent to the AWS_ACCESS_KEY_ID environment variable."}, "aws_secret_access_key": {"type": "string", "title": "AWS Secret Access Key", "format": "password", "example": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY", "writeOnly": true, "description": "Equivalent to the AWS_SECRET_ACCESS_KEY environment variable."}}, "description": "Store data as a file on AWS S3.", "secret_fields": ["aws_access_key_id", "aws_secret_access_key"], "block_type_slug": "s3"}	sha256:77690b4ef54ef3edc93fca6ac54bc540a32ca07169e91aecd36e49b2e1eeebc5	70a595b3-dce7-41cd-a9f7-f202405d3bbb	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
2d45dc2e-27c6-4464-ba4f-e500aac0f6a1	2022-09-19 00:02:39.967599+00	2022-09-19 00:02:39.96761+00	{"type": "object", "title": "GCS", "required": ["bucket_path"], "properties": {"project": {"type": "string", "title": "Project", "description": "The project the GCS bucket resides in. If not provided, the project will be inferred from the credentials or environment."}, "bucket_path": {"type": "string", "title": "Bucket Path", "example": "my-bucket/a-directory-within", "description": "A GCS bucket path."}, "service_account_info": {"type": "string", "title": "Service Account Info", "format": "password", "writeOnly": true, "description": "The contents of a service account keyfile as a JSON string."}}, "description": "Store data as a file on Google Cloud Storage.", "secret_fields": ["service_account_info"], "block_type_slug": "gcs"}	sha256:1daf535b60cf9304103bcb4015280a30fd6bdd9686aa0c059eb9715082b5b3ec	41de43c2-847e-4640-a831-06dba0fe16b2	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
14d49752-f4a0-4520-b8a5-963bd53d239a	2022-09-19 00:02:39.980344+00	2022-09-19 00:02:39.980354+00	{"type": "object", "title": "Azure", "required": ["bucket_path"], "properties": {"bucket_path": {"type": "string", "title": "Bucket Path", "example": "my-bucket/a-directory-within", "description": "An Azure storage bucket path."}, "azure_storage_account_key": {"type": "string", "title": "Azure storage account key", "format": "password", "writeOnly": true, "description": "Equivalent to the AZURE_STORAGE_ACCOUNT_KEY environment variable."}, "azure_storage_account_name": {"type": "string", "title": "Azure storage account name", "format": "password", "writeOnly": true, "description": "Equivalent to the AZURE_STORAGE_ACCOUNT_NAME environment variable."}, "azure_storage_connection_string": {"type": "string", "title": "Azure storage connection string", "format": "password", "writeOnly": true, "description": "Equivalent to the AZURE_STORAGE_CONNECTION_STRING environment variable."}}, "description": "Store data as a file on Azure Datalake and Azure Blob Storage.", "secret_fields": ["azure_storage_connection_string", "azure_storage_account_name", "azure_storage_account_key"], "block_type_slug": "azure"}	sha256:f26ee075481470374a3084b12031692f5f2c6106556d24980bf060c5a1313470	65f38963-052c-4a48-b31c-70cc3113e488	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
a44e18e8-59f7-4da9-bc90-c749624b16ad	2022-09-19 00:02:39.994469+00	2022-09-19 00:02:39.99448+00	{"type": "object", "title": "SMB", "required": ["share_path", "smb_host"], "properties": {"smb_host": {"tile": "SMB server/hostname", "type": "string", "title": "Smb Host", "description": "SMB server/hostname."}, "smb_port": {"type": "integer", "title": "SMB port", "description": "SMB port (default: 445)."}, "share_path": {"type": "string", "title": "Share Path", "example": "/SHARE/dir/subdir", "description": "SMB target (requires <SHARE>, followed by <PATH>)."}, "smb_password": {"type": "string", "title": "SMB Password", "format": "password", "writeOnly": true, "description": "Password for SMB access."}, "smb_username": {"type": "string", "title": "SMB Username", "format": "password", "writeOnly": true, "description": "Username with access to the target SMB SHARE."}}, "description": "Store data as a file on a SMB share.", "secret_fields": ["smb_username", "smb_password"], "block_type_slug": "smb"}	sha256:d5746a564cf05bec13770a882f76ca8e8f562c8bdc7a6d2d45732b079bf72045	e6ba54a0-fa20-4787-99ea-4c04966e6a9d	["read-path", "write-path", "get-directory", "put-directory"]	2.3.1
7bb797ae-9525-4b60-ba84-868c13c914c0	2022-09-19 00:02:40.008198+00	2022-09-19 00:02:40.008207+00	{"type": "object", "title": "GitHub", "required": ["repository"], "properties": {"reference": {"type": "string", "title": "Reference", "description": "An optional reference to pin to; can be a branch name or tag."}, "repository": {"type": "string", "title": "Repository", "description": "The URL of a GitHub repository to read from, in either HTTPS or SSH format."}}, "description": "Interact with files stored on public GitHub repositories.", "secret_fields": [], "block_type_slug": "github"}	sha256:4bf7c70ac6ff317928ababd19becb408dd4df53d7594e4a0f6756d866102f7ac	c4bb2af2-db43-4fe0-89a3-814c4db0aa40	["get-directory"]	2.3.1
10520264-eeb1-4c87-bd23-ec4664909358	2022-09-19 00:02:40.022896+00	2022-09-19 00:02:40.022906+00	{"type": "object", "title": "KubernetesClusterConfig", "required": ["config", "context_name"], "properties": {"config": {"type": "object", "title": "Config", "description": "The entire contents of a kubectl config file."}, "context_name": {"type": "string", "title": "Context Name", "description": "The name of the kubectl context to use."}}, "description": "Stores configuration for interaction with Kubernetes clusters.\\n\\nSee `from_file` for creation.", "secret_fields": [], "block_type_slug": "kubernetes-cluster-config"}	sha256:90d421e948bfbe4cdc98b124995f0edd0f84b0837549ad1390423bad8e31cf3b	7e823f3f-8628-439c-b8c1-d982b8db7ea5	[]	2.3.1
c829e463-2ff0-406d-8361-470d7c1c2d4f	2022-09-19 00:02:40.035936+00	2022-09-19 00:02:40.035947+00	{"type": "object", "title": "DockerRegistry", "required": ["username", "password", "registry_url"], "properties": {"reauth": {"type": "boolean", "title": "Reauth", "default": true, "description": "Whether or not to reauthenticate on each interaction."}, "password": {"type": "string", "title": "Password", "format": "password", "writeOnly": true, "description": "The password to log into the registry with."}, "username": {"type": "string", "title": "Username", "description": "The username to log into the registry with."}, "registry_url": {"type": "string", "title": "Registry Url", "description": "The URL to the registry. Generally, \\"http\\" or \\"https\\" can be omitted."}}, "description": "Connects to a Docker registry.\\n\\nRequires a Docker Engine to be connectable. Login information is persisted to disk\\nat the Docker default location.", "secret_fields": ["password"], "block_type_slug": "docker-registry"}	sha256:356410398f9957e9c96af04ae28875b71ca6174ac0978950b5f3641b21dc8544	f0cc98cb-3ec9-4eb8-ac73-678dc75d0723	["docker-login"]	2.3.1
3b4be05f-d65f-41e9-a25f-fa2a86ddae9f	2022-09-19 00:02:40.050048+00	2022-09-19 00:02:40.050057+00	{"type": "object", "title": "DockerContainer", "properties": {"env": {"type": "object", "title": "Env", "description": "Environment variables to set in the configured infrastructure.", "additionalProperties": {"type": "string"}}, "name": {"type": "string", "title": "Name", "description": "Display name for the configured infrastructure."}, "type": {"enum": ["docker-container"], "type": "string", "title": "Type", "default": "docker-container", "description": "The type of infrastructure."}, "image": {"type": "string", "title": "Image", "description": "Tag of a Docker image to use. Defaults to the Prefect image."}, "labels": {"type": "object", "title": "Labels", "description": "Labels applied to the infrastructure for metadata purposes.", "additionalProperties": {"type": "string"}}, "command": {"type": "array", "items": {"type": "string"}, "title": "Command", "default": ["python", "-m", "prefect.engine"], "description": "A list of strings specifying the command to run in the to start the flow run. In most cases you should not change this."}, "volumes": {"type": "array", "items": {"type": "string"}, "title": "Volumes", "description": "A list of volume mount strings in the format of \\"local_path:container_path\\"."}, "networks": {"type": "array", "items": {"type": "string"}, "title": "Networks", "description": "A list of strings specifying Docker networks to connect the container to."}, "auto_remove": {"type": "boolean", "title": "Auto Remove", "default": false, "description": "If set, the container will be removed on completion."}, "network_mode": {"type": "string", "title": "Network Mode", "description": "The network mode for the created container (e.g. host, bridge). If 'networks' is set, this cannot be set."}, "stream_output": {"type": "boolean", "title": "Stream Output", "default": true, "description": "If set, the output will be streamed from the container to local standard output."}, "image_registry": {"$ref": "#/definitions/DockerRegistry"}, "image_pull_policy": {"allOf": [{"$ref": "#/definitions/ImagePullPolicy"}], "description": "Specifies if the image should be pulled."}}, "definitions": {"ImagePullPolicy": {"enum": ["IF_NOT_PRESENT", "ALWAYS", "NEVER"], "type": "string", "title": "ImagePullPolicy", "description": "An enumeration."}}, "description": "Runs a command in a container.\\n\\nRequires a Docker Engine to be connectable. Docker settings will be retrieved from\\nthe environment.", "secret_fields": ["image_registry.password"], "block_type_slug": "docker-container"}	sha256:75c2d60c4d3c88223749c824e235a824dba42384398e73fa343f408620b1f6d9	4aa9595e-d5ba-45ce-8faa-8b9775c2fa69	["run-infrastructure"]	2.3.1
8d6640da-800c-4965-a4cd-7fe2a21956eb	2022-09-19 00:02:40.075091+00	2022-09-19 00:02:40.075104+00	{"type": "object", "title": "KubernetesJob", "properties": {"env": {"type": "object", "title": "Env", "description": "Environment variables to set in the configured infrastructure.", "additionalProperties": {"type": "string"}}, "job": {"type": "object", "title": "Base Job Manifest", "description": "The base manifest for the Kubernetes Job."}, "name": {"type": "string", "title": "Name", "description": "Display name for the configured infrastructure."}, "type": {"enum": ["kubernetes-job"], "type": "string", "title": "Type", "default": "kubernetes-job", "description": "The type of infrastructure."}, "image": {"type": "string", "title": "Image", "description": "The tag of a Docker image to use for the job. Defaults to the Prefect image."}, "labels": {"type": "object", "title": "Labels", "description": "Labels applied to the infrastructure for metadata purposes.", "additionalProperties": {"type": "string"}}, "command": {"type": "array", "items": {"type": "string"}, "title": "Command", "default": ["python", "-m", "prefect.engine"], "description": "A list of strings specifying the command to run in the to start the flow run. In most cases you should not change this."}, "namespace": {"type": "string", "title": "Namespace", "default": "default", "description": "The Kubernetes namespace to use for this job."}, "stream_output": {"type": "boolean", "title": "Stream Output", "default": true, "description": "If set, output will be streamed from the job to local standard output."}, "cluster_config": {"$ref": "#/definitions/KubernetesClusterConfig"}, "customizations": {"type": "array", "items": {"type": "object", "additionalProperties": {"type": "string"}}, "title": "Customizations", "format": "rfc6902", "description": "A list of JSON 6902 patches to apply to the base Job manifest."}, "image_pull_policy": {"allOf": [{"$ref": "#/definitions/KubernetesImagePullPolicy"}], "description": "The Kubernetes image pull policy to use for job containers."}, "service_account_name": {"type": "string", "title": "Service Account Name", "description": "The Kubernetes service account to use for this job."}, "job_watch_timeout_seconds": {"type": "integer", "title": "Job Watch Timeout Seconds", "default": 5, "description": "Number of seconds to watch for job creation before timing out."}, "pod_watch_timeout_seconds": {"type": "integer", "title": "Pod Watch Timeout Seconds", "default": 60, "description": "Number of seconds to watch for pod creation before timing out."}}, "definitions": {"KubernetesImagePullPolicy": {"enum": ["IfNotPresent", "Always", "Never"], "title": "KubernetesImagePullPolicy", "description": "An enumeration."}}, "description": "Runs a command as a Kubernetes Job.", "secret_fields": [], "block_type_slug": "kubernetes-job"}	sha256:dba5b70f9b3d1f587dc822f6bc9e5671eb967856a9f833f4f72e4265f231a0f4	7dd0a154-fd05-47b2-abd9-b64930f3d7f1	["run-infrastructure"]	2.3.1
f0421dff-a3d0-4459-a323-db876ad82401	2022-09-19 00:02:40.093947+00	2022-09-19 00:02:40.093957+00	{"type": "object", "title": "Process", "properties": {"env": {"type": "object", "title": "Env", "description": "Environment variables to set in the configured infrastructure.", "additionalProperties": {"type": "string"}}, "name": {"type": "string", "title": "Name", "description": "Display name for the configured infrastructure."}, "type": {"enum": ["process"], "type": "string", "title": "Type", "default": "process", "description": "The type of infrastructure."}, "labels": {"type": "object", "title": "Labels", "description": "Labels applied to the infrastructure for metadata purposes.", "additionalProperties": {"type": "string"}}, "command": {"type": "array", "items": {"type": "string"}, "title": "Command", "default": ["python", "-m", "prefect.engine"], "description": "A list of strings specifying the command to run in the to start the flow run. In most cases you should not change this."}, "stream_output": {"type": "boolean", "title": "Stream Output", "default": true, "description": "If set, output will be streamed from the process to local standard output."}}, "description": "Run a command in a new process.\\n\\nCurrent environment variables and Prefect settings will be included in the created\\nprocess. Configured environment variables will override any current environment\\nvariables.", "secret_fields": [], "block_type_slug": "process"}	sha256:d28332d78ac90882bfeeef79f98cd26c99cda6a7c6d3a48d56a6bd67d7360648	b73f6525-cee3-402f-ba3e-af01ed383be9	["run-infrastructure"]	2.3.1
\.


--
-- Data for Name: block_schema_reference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block_schema_reference (id, created, updated, name, parent_block_schema_id, reference_block_schema_id) FROM stdin;
5615d09f-ae34-47b0-9df0-81edfb2d951f	2022-09-19 00:02:40.057926+00	2022-09-19 00:02:40.057942+00	image_registry	3b4be05f-d65f-41e9-a25f-fa2a86ddae9f	c829e463-2ff0-406d-8361-470d7c1c2d4f
f73fb6fd-9a29-4f90-b573-09bd8c863192	2022-09-19 00:02:40.08148+00	2022-09-19 00:02:40.08149+00	cluster_config	8d6640da-800c-4965-a4cd-7fe2a21956eb	10520264-eeb1-4c87-bd23-ec4664909358
\.


--
-- Data for Name: block_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block_type (id, created, updated, name, logo_url, documentation_url, description, code_example, is_protected, slug) FROM stdin;
65af4d14-7c33-47c5-aab7-31fcaa87a2a0	2022-09-19 00:02:39.920966+00	2022-09-28 15:48:27.311255+00	Local File System	https://images.ctfassets.net/gm98wzqotmnx/EVKjxM7fNyi4NGUSkeTEE/95c958c5dd5a56c59ea5033e919c1a63/image1.png?h=250	\N	Store data as a file on a local file system.	Load stored local file system config:\n```python\nfrom prefect.filesystems import LocalFileSystem\n\nlocal_file_system_block = LocalFileSystem.load("BLOCK_NAME")\n```	f	local-file-system
e789e69f-6a5a-492c-8ea2-fea2d289c282	2022-09-19 00:02:39.825442+00	2022-09-28 13:55:47.691631+00	Slack Webhook	https://images.ctfassets.net/gm98wzqotmnx/7dkzINU9r6j44giEFuHuUC/85d4cd321ad60c1b1e898bc3fbd28580/5cb480cd5f1b6d3fbadece79.png?h=250	\N	Enables sending notifications via a provided Slack webhook.	Load a saved Slack webhook and send a message:\n```python\nfrom prefect.blocks.notifications import SlackWebhook\n\nslack_webhook_block = SlackWebhook.load("BLOCK_NAME")\nslack_webhook_block.notify("Hello from Prefect!")\n```	f	slack-webhook
3992f61d-0a7e-47f1-a450-75a1ed5473f2	2022-09-19 00:02:39.859336+00	2022-09-28 13:55:47.78854+00	JSON	https://images.ctfassets.net/gm98wzqotmnx/19W3Di10hhb4oma2Qer0x6/764d1e7b4b9974cd268c775a488b9d26/image16.png?h=250	\N	A block that represents JSON	Load a stored JSON value:\n```python\nfrom prefect.blocks.system import JSON\n\njson_block = JSON.load("BLOCK_NAME")\n```	f	json
e7d3bbd3-06b8-40ff-969b-c7a236ca9961	2022-09-19 00:02:39.873158+00	2022-09-28 13:55:47.808951+00	String	https://images.ctfassets.net/gm98wzqotmnx/4zjrZmh9tBrFiikeB44G4O/2ce1dbbac1c8e356f7c429e0f8bbb58d/image10.png?h=250	\N	A block that represents a string	Load a stored string value:\n```python\nfrom prefect.blocks.system import String\n\nstring_block = String.load("BLOCK_NAME")\n```	f	string
dd995a8d-16ec-43ff-a6bb-9593da239594	2022-09-19 00:02:39.890798+00	2022-09-28 13:55:47.827364+00	Date Time	https://images.ctfassets.net/gm98wzqotmnx/1gmljt5UBcAwEXHPnIofcE/0f3cf1da45b8b2df846e142ab52b1778/image21.png?h=250	\N	A block that represents a datetime	Load a stored JSON value:\n```python\nfrom prefect.blocks.system import DateTime\n\ndata_time_block = DateTime.load("BLOCK_NAME")\n```	f	date-time
7d97f0e1-b7c2-4415-89f8-ae130dbe13cc	2022-09-19 00:02:39.905016+00	2022-09-28 13:55:47.847722+00	Secret	https://images.ctfassets.net/gm98wzqotmnx/5uUmyGBjRejYuGTWbTxz6E/3003e1829293718b3a5d2e909643a331/image8.png?h=250	\N	A block that represents a secret value. The value stored in this block will be obfuscated when\nthis block is logged or shown in the UI.	```python\nfrom prefect.blocks.system import Secret\n\nsecret_block = Secret.load("BLOCK_NAME")\n\n# Access the stored secret\nsecret_block.get()\n```	f	secret
93d4c468-974a-4b18-851e-cb013c0ebe2b	2022-09-19 00:02:39.935369+00	2022-09-28 13:55:47.887167+00	Remote File System	https://images.ctfassets.net/gm98wzqotmnx/4CxjycqILlT9S9YchI7o1q/ee62e2089dfceb19072245c62f0c69d2/image12.png?h=250	\N	Store data as a file on a remote file system.\n\nSupports any remote file system supported by `fsspec`. The file system is specified\nusing a protocol. For example, "s3://my-bucket/my-folder/" will use S3.	Load stored remote file system config:\n```python\nfrom prefect.filesystems import RemoteFileSystem\n\nremote_file_system_block = RemoteFileSystem.load("BLOCK_NAME")\n```	f	remote-file-system
70a595b3-dce7-41cd-a9f7-f202405d3bbb	2022-09-19 00:02:39.94837+00	2022-09-28 13:55:47.90357+00	S3	https://images.ctfassets.net/gm98wzqotmnx/1jbV4lceHOjGgunX15lUwT/db88e184d727f721575aeb054a37e277/aws.png?h=250	\N	Store data as a file on AWS S3.	Load stored S3 config:\n```python\nfrom prefect.filesystems import S3\n\ns3_block = S3.load("BLOCK_NAME")\n```	f	s3
41de43c2-847e-4640-a831-06dba0fe16b2	2022-09-19 00:02:39.961362+00	2022-09-28 13:55:47.924732+00	GCS	https://images.ctfassets.net/gm98wzqotmnx/4CD4wwbiIKPkZDt4U3TEuW/c112fe85653da054b6d5334ef662bec4/gcp.png?h=250	\N	Store data as a file on Google Cloud Storage.	Load stored GCS config:\n```python\nfrom prefect.filesystems import GCS\n\ngcs_block = GCS.load("BLOCK_NAME")\n```	f	gcs
65f38963-052c-4a48-b31c-70cc3113e488	2022-09-19 00:02:39.974235+00	2022-09-28 13:55:47.953214+00	Azure	https://images.ctfassets.net/gm98wzqotmnx/6AiQ6HRIft8TspZH7AfyZg/39fd82bdbb186db85560f688746c8cdd/azure.png?h=250	\N	Store data as a file on Azure Datalake and Azure Blob Storage.	Load stored Azure config:\n```python\nfrom prefect.filesystems import Azure\n\naz_block = Azure.load("BLOCK_NAME")\n```	f	azure
e6ba54a0-fa20-4787-99ea-4c04966e6a9d	2022-09-19 00:02:39.988146+00	2022-09-28 13:55:47.969174+00	SMB	\N	\N	Store data as a file on a SMB share.	Load stored SMB config:\n\n```python\nfrom prefect.filesystems import SMB\nsmb_block = SMB.load("BLOCK_NAME")\n```	f	smb
c4bb2af2-db43-4fe0-89a3-814c4db0aa40	2022-09-19 00:02:40.001902+00	2022-09-28 13:55:47.983651+00	GitHub	https://images.ctfassets.net/gm98wzqotmnx/187oCWsD18m5yooahq1vU0/ace41e99ab6dc40c53e5584365a33821/github.png?h=250	\N	Interact with files stored on public GitHub repositories.	\N	f	github
7e823f3f-8628-439c-b8c1-d982b8db7ea5	2022-09-19 00:02:40.016009+00	2022-09-28 13:55:47.9988+00	Kubernetes Cluster Config	https://images.ctfassets.net/gm98wzqotmnx/1zrSeY8DZ1MJZs2BAyyyGk/8e4792f00a0c808ad1ad5126126fa5f8/Kubernetes_logo_without_workmark.svg.png?h=250	\N	Stores configuration for interaction with Kubernetes clusters.\n\nSee `from_file` for creation.	Load a saved Kubernetes cluster config:\n```python\nfrom prefect.blocks.kubernetes import KubernetesClusterConfig\n\ncluster_config_block = KubernetesClusterConfig.load("BLOCK_NAME")\n```	f	kubernetes-cluster-config
f0cc98cb-3ec9-4eb8-ac73-678dc75d0723	2022-09-19 00:02:40.029674+00	2022-09-28 13:55:48.023658+00	Docker Registry	https://images.ctfassets.net/gm98wzqotmnx/2IfXXfMq66mrzJBDFFCHTp/6d8f320d9e4fc4393f045673d61ab612/Moby-logo.png?h=250	\N	Connects to a Docker registry.\n\nRequires a Docker Engine to be connectable. Login information is persisted to disk\nat the Docker default location.	\N	f	docker-registry
4aa9595e-d5ba-45ce-8faa-8b9775c2fa69	2022-09-19 00:02:40.043491+00	2022-09-28 13:55:48.041171+00	Docker Container	https://images.ctfassets.net/gm98wzqotmnx/2IfXXfMq66mrzJBDFFCHTp/6d8f320d9e4fc4393f045673d61ab612/Moby-logo.png?h=250	\N	Runs a command in a container.\n\nRequires a Docker Engine to be connectable. Docker settings will be retrieved from\nthe environment.	\N	f	docker-container
7dd0a154-fd05-47b2-abd9-b64930f3d7f1	2022-09-19 00:02:40.066591+00	2022-09-28 13:55:48.060847+00	Kubernetes Job	\N	\N	Runs a command as a Kubernetes Job.	\N	f	kubernetes-job
b73f6525-cee3-402f-ba3e-af01ed383be9	2022-09-19 00:02:40.087626+00	2022-09-28 13:55:48.084247+00	Process	\N	\N	Run a command in a new process.\n\nCurrent environment variables and Prefect settings will be included in the created\nprocess. Configured environment variables will override any current environment\nvariables.	\N	f	process
\.


--
-- Data for Name: concurrency_limit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.concurrency_limit (id, created, updated, tag, concurrency_limit, active_slots) FROM stdin;
\.


--
-- Data for Name: configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuration (id, created, updated, key, value) FROM stdin;
8ecbf605-bfba-4c92-8fde-96343ae6120b	2022-09-19 00:02:40.216817+00	2022-09-19 00:02:40.216827+00	TELEMETRY_SESSION	{"session_id": "09104c90-cce6-4c30-834c-071b73848013", "session_start_timestamp": "2022-09-19T00:02:40.214932+00:00"}
3982393a-eb26-45f7-9b2d-89bbe120e9d5	2022-09-28 01:53:24.320189+00	2022-09-28 01:53:24.32021+00	ENCRYPTION_KEY	{"fernet_key": "drFD0YRHo-qu4jEYkkNMuwRbShgaBJBcENDlnzFR4I8="}
\.


--
-- Data for Name: deployment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployment (id, created, updated, name, schedule, is_schedule_active, tags, parameters, flow_data, flow_id, infrastructure_document_id, description, manifest_path, parameter_openapi_schema, storage_document_id, version, infra_overrides, path, entrypoint, work_queue_name) FROM stdin;
6cb560fe-0ad3-4f34-aa7a-d74f1f513155	2022-09-28 02:08:27.940231+00	2022-09-28 15:38:04.878845+00	sample-flow	{"interval": 3600.0, "timezone": "UTC", "anchor_date": "2022-09-28T14:48:26.804000+00:00"}	t	[]	{}	\N	567df184-ad88-471c-8a4b-d99024e39ca2	6e8afe07-28d1-4e98-a930-c3074e5775ae	\N	\N	{"type": "object", "title": "Parameters", "properties": {}}	\N	afeb0f8d875384aa6794f7dd5045d8a2	{"env": {"PREFECT_API_URL": "http://orion:4200/api", "PREFECT_LOGGING_LEVEL": "INFO"}}	/root	/root/flows/example.py:main	my_queue
\.


--
-- Data for Name: flow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow (id, created, updated, name, tags) FROM stdin;
567df184-ad88-471c-8a4b-d99024e39ca2	2022-09-28 02:08:27.832676+00	2022-09-28 02:08:27.832688+00	main flow	[]
\.


--
-- Data for Name: flow_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow_run (id, created, updated, name, state_type, run_count, expected_start_time, next_scheduled_start_time, start_time, end_time, total_run_time, flow_version, parameters, idempotency_key, context, empirical_policy, tags, auto_scheduled, flow_id, deployment_id, parent_task_run_id, state_id, state_name, infrastructure_document_id, work_queue_name) FROM stdin;
9db7dfc4-8866-4e70-bdc4-615371a66765	2022-09-28 02:22:54.024187+00	2022-09-28 02:22:57.384444+00	cyber-alligator	COMPLETED	1	2022-09-28 02:22:54.021815+00	\N	2022-09-28 02:22:57.30747+00	2022-09-28 02:22:57.383615+00	00:00:00.076145	e38b7da798ad22be9cf5fe1138074c1a	{}	\N	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	[]	f	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	149c1daf-84fd-478c-8af7-be130bffd278	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
754157d4-6f3d-4c39-92ff-f0e750f916f4	2022-09-28 02:27:00.564111+00	2022-09-28 02:27:02.480116+00	deft-woodpecker	COMPLETED	1	2022-09-28 02:27:00.558909+00	\N	2022-09-28 02:27:02.425553+00	2022-09-28 02:27:02.478996+00	00:00:00.053443	87e9e5ff453ff0a375ff9ae528e747de	{}	\N	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	[]	f	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	f375f214-f55d-43c7-8149-54e8e7b7ccbb	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
1390466b-f913-47cd-85ce-6b5c1000afb0	2022-09-28 02:30:28.529946+00	2022-09-28 02:31:00.458572+00	mottled-elephant	COMPLETED	1	2022-09-28 02:30:28.526081+00	\N	2022-09-28 02:30:33.824044+00	2022-09-28 02:31:00.457722+00	00:00:26.633678	bda62accee247eb4fe2d9b2ff9486aca	{}	\N	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	[]	f	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	484d4ec5-7fea-420f-9907-b76b61dafeee	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d9d33d26-e17d-4930-a659-1fc9b24c9142	2022-09-28 12:34:59.179723+00	2022-09-28 12:35:39.821243+00	wealthy-pig	COMPLETED	1	2022-09-28 12:34:59.176367+00	\N	2022-09-28 12:35:05.547705+00	2022-09-28 12:35:39.820282+00	00:00:34.272577	f0f67afc1be89aadaf3f00c9bc80d979	{}	\N	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	[]	f	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9c0ffab5-8bfd-4fd2-92c3-9e7b5c467456	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
a44524c8-7d21-4dfc-9478-54f7f083751e	2022-09-28 15:44:29.593588+00	2022-09-28 15:45:28.464545+00	true-badger	COMPLETED	1	2022-09-28 15:44:29.590122+00	\N	2022-09-28 15:44:35.515562+00	2022-09-28 15:45:28.463615+00	00:00:52.948053	334e9230c30c1cb5a498097d8ad2f01c	{}	\N	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	[]	f	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	dadfaf36-75f1-48a7-a13c-8074040623c3	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d6642e63-c00d-48f9-8c5c-2d3b606a8441	2022-09-28 15:38:09.399765+00	2022-09-28 15:38:09.388175+00	idealistic-trogon	SCHEDULED	0	2022-09-28 22:48:26.804+00	2022-09-28 22:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T22:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	850df49a-3bf6-4ed8-8a29-19045533b494	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
a5ec91ba-edfc-4411-a0bf-7419a090323c	2022-09-28 15:38:09.399786+00	2022-09-28 15:38:09.388175+00	nimble-perch	SCHEDULED	0	2022-09-28 23:48:26.804+00	2022-09-28 23:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T23:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	407d8f35-5113-4ed5-bf6a-27d5ef2e9d48	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
fec75f8e-b642-4085-98c1-660d6452f1fe	2022-09-28 15:48:48.243265+00	2022-09-28 15:48:48.22731+00	vehement-toucan	SCHEDULED	0	2022-10-02 19:48:26.804+00	2022-10-02 19:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T19:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	1683c6ac-6fb9-4143-8b4a-a93367c5b418	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
3046a308-c64b-4a73-902a-a5546b6e5563	2022-09-28 15:38:09.399552+00	2022-09-28 15:49:08.146425+00	convivial-manatee	COMPLETED	1	2022-09-28 15:48:26.804+00	\N	2022-09-28 15:48:27.374574+00	2022-09-28 15:49:08.145159+00	00:00:40.770585	334e9230c30c1cb5a498097d8ad2f01c	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T15:48:26.804000+00:00	{}	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	efc8463b-efb7-4b94-ae14-9a1e18ccd632	Completed	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
79dc1173-4f6c-42ec-82b8-423a132ee7d7	2022-09-28 15:38:09.401118+00	2022-09-28 15:38:09.388175+00	mottled-mandrill	SCHEDULED	0	2022-10-02 02:48:26.804+00	2022-10-02 02:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T02:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	e3914460-a151-492a-ab7a-58c595428371	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
027eed8a-4522-4630-b3ca-f59e442efb3e	2022-09-28 15:38:09.401134+00	2022-09-28 15:38:09.388175+00	discerning-muskox	SCHEDULED	0	2022-10-02 03:48:26.804+00	2022-10-02 03:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T03:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	4928a04c-5a1f-4cf2-958b-fb052f8ecf21	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
46daa6c5-cd2e-4ad5-b743-4803535548b4	2022-09-28 15:38:09.40115+00	2022-09-28 15:38:09.388175+00	taupe-fennec	SCHEDULED	0	2022-10-02 04:48:26.804+00	2022-10-02 04:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T04:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	179a5de3-ca28-4b9e-826a-9cfa3baf47b8	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
95d52758-5476-4ba4-845f-c72ac2dcb9b4	2022-09-28 15:38:09.401167+00	2022-09-28 15:38:09.388175+00	rainbow-lobster	SCHEDULED	0	2022-10-02 05:48:26.804+00	2022-10-02 05:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T05:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	f7afe3f3-8622-4ac7-8e27-5d47d7981457	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
971d3cf0-1423-4f92-a136-047fd6a5fbdf	2022-09-28 15:38:09.401185+00	2022-09-28 15:38:09.388175+00	angelic-chital	SCHEDULED	0	2022-10-02 06:48:26.804+00	2022-10-02 06:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T06:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	3e55c54f-dd27-48f7-815f-a97b466c6e24	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
a80db1d7-3ab0-42a7-8c55-196242af59e8	2022-09-28 15:38:09.4012+00	2022-09-28 15:38:09.388175+00	stalwart-wombat	SCHEDULED	0	2022-10-02 07:48:26.804+00	2022-10-02 07:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T07:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	09bd9b25-a0ed-494c-becd-aa0b38c97366	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
07fe6e8a-0258-4d26-945e-65ac42dea9e6	2022-09-28 15:38:09.401313+00	2022-09-28 15:38:09.388175+00	vagabond-worm	SCHEDULED	0	2022-10-02 14:48:26.804+00	2022-10-02 14:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T14:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	3e586072-f4aa-4f17-b1ea-5d59801a85aa	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
044163ae-82fe-4039-abd3-a0908048f8b2	2022-09-28 15:38:09.401329+00	2022-09-28 15:38:09.388175+00	olive-taipan	SCHEDULED	0	2022-10-02 15:48:26.804+00	2022-10-02 15:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T15:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d8c2f8e7-6007-4097-9f15-210d6a480e2c	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
9c07abb2-a0b0-49c5-a211-fb4e0c099798	2022-09-28 15:38:09.401346+00	2022-09-28 15:38:09.388175+00	wakeful-dove	SCHEDULED	0	2022-10-02 16:48:26.804+00	2022-10-02 16:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T16:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9f15091e-c4d5-4f74-8b85-dffa4027396e	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
ee4ba0cf-01c8-4309-89d8-0b267e2ef4af	2022-09-28 15:38:09.401361+00	2022-09-28 15:38:09.388175+00	infrared-chupacabra	SCHEDULED	0	2022-10-02 17:48:26.804+00	2022-10-02 17:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T17:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d2cef1cc-2291-4b3a-95a1-cf1a3262ba08	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d7781305-7fca-407a-a497-0dc8e1c464a2	2022-09-28 15:38:09.39961+00	2022-09-28 15:38:09.388175+00	simple-dormouse	SCHEDULED	0	2022-09-28 16:48:26.804+00	2022-09-28 16:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T16:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	cc608db8-269d-4856-a8dd-4cc6afe3ca93	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
98e7bc2d-cb52-4483-a5b5-c7b9e32bd2f4	2022-09-28 15:38:09.399633+00	2022-09-28 15:38:09.388175+00	whimsical-coucal	SCHEDULED	0	2022-09-28 17:48:26.804+00	2022-09-28 17:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T17:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	10336ca6-ef4d-4086-b322-5c5c40f12806	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
4b94fe49-d1cc-452f-ba8c-0f4e8de72652	2022-09-28 15:38:09.399653+00	2022-09-28 15:38:09.388175+00	prehistoric-gecko	SCHEDULED	0	2022-09-28 18:48:26.804+00	2022-09-28 18:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T18:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ab125d03-5557-4d4d-bb44-919ed1e393d9	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
91045948-4c4c-45f6-a392-2786f9a3333d	2022-09-28 15:38:09.399672+00	2022-09-28 15:38:09.388175+00	witty-kestrel	SCHEDULED	0	2022-09-28 19:48:26.804+00	2022-09-28 19:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T19:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	3358c0ab-abf2-41bb-bc70-abeb8882a7c0	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
321e659d-8ea5-464c-aa4a-c72f79af6e15	2022-09-28 15:38:09.399691+00	2022-09-28 15:38:09.388175+00	merciful-dodo	SCHEDULED	0	2022-09-28 20:48:26.804+00	2022-09-28 20:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T20:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	67ce0833-e39c-43d0-8031-e1e285274631	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
5377ed90-fc91-4194-9b5d-0e1d2fef43eb	2022-09-28 15:38:09.399709+00	2022-09-28 15:38:09.388175+00	busy-boobook	SCHEDULED	0	2022-09-28 21:48:26.804+00	2022-09-28 21:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-28T21:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	0aab9be7-519f-4250-9e95-51544ae265bc	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
833c9e40-bd33-4e19-96bb-e00faa904040	2022-09-28 15:38:09.399803+00	2022-09-28 15:38:09.388175+00	tangible-hoatzin	SCHEDULED	0	2022-09-29 00:48:26.804+00	2022-09-29 00:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T00:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	e2deaf27-5fdc-472f-b27d-c381e833a94c	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
e7e6d989-0a75-46a6-914c-999d13a752e3	2022-09-28 15:38:09.39982+00	2022-09-28 15:38:09.388175+00	mysterious-sawfish	SCHEDULED	0	2022-09-29 01:48:26.804+00	2022-09-29 01:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T01:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	caa9a944-f30b-4960-bb9a-19084b2402a6	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
1e0ac5e3-910c-45cd-bb35-6762842b2a0d	2022-09-28 15:38:09.399837+00	2022-09-28 15:38:09.388175+00	golden-caracara	SCHEDULED	0	2022-09-29 02:48:26.804+00	2022-09-29 02:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T02:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	1a97050d-ef5e-4100-81c6-e5747398a216	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
f7c0f281-d7a9-405d-98b7-7f12701a042f	2022-09-28 15:38:09.399854+00	2022-09-28 15:38:09.388175+00	fragrant-mongrel	SCHEDULED	0	2022-09-29 03:48:26.804+00	2022-09-29 03:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T03:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	2119c3e8-daa0-4e34-836e-331f98e5dcfc	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
062334a9-1b2f-4c3c-b45c-0e0aaa6102bd	2022-09-28 15:38:09.399871+00	2022-09-28 15:38:09.388175+00	true-lemur	SCHEDULED	0	2022-09-29 04:48:26.804+00	2022-09-29 04:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T04:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	0efe98c3-58e3-4f83-a22d-34269455b619	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
980e35f9-8c43-48f3-9c95-ed1f36303aa8	2022-09-28 15:38:09.399888+00	2022-09-28 15:38:09.388175+00	maroon-taipan	SCHEDULED	0	2022-09-29 05:48:26.804+00	2022-09-29 05:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T05:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	6265d72e-e99a-4c78-9fd7-fba2c69a9ec6	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
cfa2ec9c-06ec-4fd7-899d-64f836642c7b	2022-09-28 15:38:09.399904+00	2022-09-28 15:38:09.388175+00	great-chachalaca	SCHEDULED	0	2022-09-29 06:48:26.804+00	2022-09-29 06:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T06:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	60cc2887-cc73-4cc4-8c34-db3944053286	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
664771b2-bf16-4002-9dac-01019d7f6f0e	2022-09-28 15:38:09.39992+00	2022-09-28 15:38:09.388175+00	illegal-stingray	SCHEDULED	0	2022-09-29 07:48:26.804+00	2022-09-29 07:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T07:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	f42b54ac-01cc-4724-982e-41a589292c15	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
82d2924b-0d7a-4081-abe4-8b34b3c9e422	2022-09-28 15:38:09.399937+00	2022-09-28 15:38:09.388175+00	nebulous-chital	SCHEDULED	0	2022-09-29 08:48:26.804+00	2022-09-29 08:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T08:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	13ae6d84-5744-4fe3-b81d-37f74e3747dc	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
59b813b6-0803-4b50-8e9f-433dc87f91ea	2022-09-28 15:38:09.399953+00	2022-09-28 15:38:09.388175+00	spiked-dove	SCHEDULED	0	2022-09-29 09:48:26.804+00	2022-09-29 09:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T09:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	25a8a3b9-7059-430d-884b-fcc28fdb46a3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
4d00d28e-2ab3-4a3b-80a6-01acb069530e	2022-09-28 15:38:09.399969+00	2022-09-28 15:38:09.388175+00	bold-puma	SCHEDULED	0	2022-09-29 10:48:26.804+00	2022-09-29 10:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T10:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5872b0b2-acfc-485d-81bf-cc48992a7edc	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
226a01a6-1cea-4db1-91e2-915b25e24e02	2022-09-28 15:38:09.399985+00	2022-09-28 15:38:09.388175+00	jovial-worm	SCHEDULED	0	2022-09-29 11:48:26.804+00	2022-09-29 11:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T11:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d1d69cd3-5ebc-44da-bf4b-030fa7f3a10e	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
f444c6da-3bca-417a-bfa1-4b917417a984	2022-09-28 15:38:09.400002+00	2022-09-28 15:38:09.388175+00	ludicrous-harrier	SCHEDULED	0	2022-09-29 12:48:26.804+00	2022-09-29 12:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T12:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	0743a14a-f899-496d-a18b-f35bf6e15d1d	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
dc9c9e7f-8f4a-4aee-bd65-92b842e5f4f3	2022-09-28 15:38:09.400018+00	2022-09-28 15:38:09.388175+00	quixotic-seal	SCHEDULED	0	2022-09-29 13:48:26.804+00	2022-09-29 13:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T13:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	1b219b47-33db-48a4-983e-11cf6fe68430	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
e48fdebe-20ef-4f6a-8901-9f9684994998	2022-09-28 15:38:09.400035+00	2022-09-28 15:38:09.388175+00	benign-flamingo	SCHEDULED	0	2022-09-29 14:48:26.804+00	2022-09-29 14:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T14:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	acaf90e1-c779-4d59-a105-2af4fb5baf5c	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
dc35dc1c-4356-43b5-a729-95aeebd90492	2022-09-28 15:38:09.400051+00	2022-09-28 15:38:09.388175+00	strict-wildebeest	SCHEDULED	0	2022-09-29 15:48:26.804+00	2022-09-29 15:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T15:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	298c7ce2-9869-481c-bb22-7cd30252635a	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
5ba4a63f-46ed-4007-8941-2cc493d250fc	2022-09-28 15:38:09.400067+00	2022-09-28 15:38:09.388175+00	rich-mantis	SCHEDULED	0	2022-09-29 16:48:26.804+00	2022-09-29 16:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T16:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	46c62b93-e4a4-4001-9907-5219e4bcdfaf	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
2c3b314b-5c20-46b1-826a-fec85688511f	2022-09-28 15:38:09.400113+00	2022-09-28 15:38:09.388175+00	miniature-cricket	SCHEDULED	0	2022-09-29 17:48:26.804+00	2022-09-29 17:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T17:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	2cbe914e-3f30-4a12-8e12-e79952e8e0e3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
3a8ddad0-c43a-4f81-bfe7-0e0eee1d5266	2022-09-28 15:38:09.400135+00	2022-09-28 15:38:09.388175+00	resolute-hog	SCHEDULED	0	2022-09-29 18:48:26.804+00	2022-09-29 18:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T18:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	19acb526-1807-4e9b-ad41-06d1d612b15c	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
f8f95285-401c-43c7-af16-858557fa57d6	2022-09-28 15:38:09.400153+00	2022-09-28 15:38:09.388175+00	uppish-mantis	SCHEDULED	0	2022-09-29 19:48:26.804+00	2022-09-29 19:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T19:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	a85bff08-74d5-4d9c-b38f-40f30a61bddb	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
545dc5c8-6a92-4e65-9e4b-2959139201db	2022-09-28 15:38:09.400171+00	2022-09-28 15:38:09.388175+00	annoying-gorilla	SCHEDULED	0	2022-09-29 20:48:26.804+00	2022-09-29 20:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T20:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	c739c843-8d55-4b03-bb16-f9bc8e28dc00	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
df9ef155-cfb0-4df5-82b6-aa86b878d8b4	2022-09-28 15:38:09.400188+00	2022-09-28 15:38:09.388175+00	archetypal-oarfish	SCHEDULED	0	2022-09-29 21:48:26.804+00	2022-09-29 21:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T21:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ed3ab153-901a-427d-acf2-4f783c762bdd	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
f2a302a1-094f-4191-9a0e-7ca399897fd9	2022-09-28 15:38:09.400205+00	2022-09-28 15:38:09.388175+00	amphibian-potoo	SCHEDULED	0	2022-09-29 22:48:26.804+00	2022-09-29 22:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T22:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	907a062f-1019-4374-8e35-45e14c10b72b	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d4f31bbb-b99a-436c-b5ca-995caa6a0db6	2022-09-28 15:38:09.400222+00	2022-09-28 15:38:09.388175+00	neon-dodo	SCHEDULED	0	2022-09-29 23:48:26.804+00	2022-09-29 23:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-29T23:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	976dea85-9fe5-4548-93a8-38fdf3f9604e	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d3edc005-0642-44b6-ac2e-da7e3f48f1a8	2022-09-28 15:38:09.400238+00	2022-09-28 15:38:09.388175+00	versatile-sawfish	SCHEDULED	0	2022-09-30 00:48:26.804+00	2022-09-30 00:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T00:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	707eda69-b68d-4f49-bcb1-4013da9e38a6	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
eaa01434-82c2-4080-a8b8-b9aaef6e4d19	2022-09-28 15:38:09.400254+00	2022-09-28 15:38:09.388175+00	rousing-jackrabbit	SCHEDULED	0	2022-09-30 01:48:26.804+00	2022-09-30 01:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T01:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	20627ddc-1def-44ad-9123-7e28fd02fd8b	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
de0507ce-4f36-488d-aaff-5663a537a020	2022-09-28 15:38:09.400271+00	2022-09-28 15:38:09.388175+00	fearless-bumblebee	SCHEDULED	0	2022-09-30 02:48:26.804+00	2022-09-30 02:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T02:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	6d267f0c-ae30-4327-a9ea-4daf0101248e	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
2173d6f3-8ac7-48f0-9c9b-38710e8a77e8	2022-09-28 15:38:09.400287+00	2022-09-28 15:38:09.388175+00	judicious-pillbug	SCHEDULED	0	2022-09-30 03:48:26.804+00	2022-09-30 03:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T03:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9cee5923-b8a3-43d3-af09-1d5ef6096c47	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
be5e4c6b-7848-44e6-aa3d-b890640e8a7f	2022-09-28 15:38:09.400304+00	2022-09-28 15:38:09.388175+00	jade-caracal	SCHEDULED	0	2022-09-30 04:48:26.804+00	2022-09-30 04:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T04:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	6ec158dc-07b5-46a1-93f7-0c8a3f202ad3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
b5bcdf2f-6d82-45f9-90e2-9e57e16ad017	2022-09-28 15:38:09.40032+00	2022-09-28 15:38:09.388175+00	exuberant-cockatoo	SCHEDULED	0	2022-09-30 05:48:26.804+00	2022-09-30 05:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T05:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	a5f249e9-6a89-4169-9439-9df6b95fe743	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
e476bf48-4e7b-4c8e-ab76-70f0eb760c10	2022-09-28 15:38:09.400337+00	2022-09-28 15:38:09.388175+00	uptight-nyala	SCHEDULED	0	2022-09-30 06:48:26.804+00	2022-09-30 06:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T06:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	2895f808-64a1-4d85-8072-d6b84f16a859	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
ae00e9b0-153c-46a4-9a04-e29206abe969	2022-09-28 15:38:09.400353+00	2022-09-28 15:38:09.388175+00	phenomenal-toucanet	SCHEDULED	0	2022-09-30 07:48:26.804+00	2022-09-30 07:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T07:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	34fa97ed-d23c-4a96-b509-1eab50349025	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
881bce4d-2854-4bfb-b361-4b94d01d2756	2022-09-28 15:38:09.400371+00	2022-09-28 15:38:09.388175+00	warping-rottweiler	SCHEDULED	0	2022-09-30 08:48:26.804+00	2022-09-30 08:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T08:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	b958579e-a5fc-474c-8a13-e604dc38d2e3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
36bc6f2a-87fc-4ab1-88e7-898ed1a9dfcb	2022-09-28 15:38:09.400391+00	2022-09-28 15:38:09.388175+00	cryptic-fox	SCHEDULED	0	2022-09-30 09:48:26.804+00	2022-09-30 09:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T09:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	1ea6a192-4f36-4d83-9b49-851604441192	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
8206875a-8cb6-4568-814c-aff2e73096f5	2022-09-28 15:38:09.400409+00	2022-09-28 15:38:09.388175+00	belligerent-otter	SCHEDULED	0	2022-09-30 10:48:26.804+00	2022-09-30 10:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T10:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5975d381-b696-4b5e-bd47-1ba09d19e018	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
4fb31268-cf39-49f0-9b00-b9138e80b9bb	2022-09-28 15:38:09.400426+00	2022-09-28 15:38:09.388175+00	natural-buffalo	SCHEDULED	0	2022-09-30 11:48:26.804+00	2022-09-30 11:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T11:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	a0ccc029-d379-492b-8fc6-462ad99f397a	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
fce080a2-709e-4307-b8d4-668dbf364dcd	2022-09-28 15:38:09.400442+00	2022-09-28 15:38:09.388175+00	hopping-lemur	SCHEDULED	0	2022-09-30 12:48:26.804+00	2022-09-30 12:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T12:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d2c6f6df-2dde-4cbd-9fc6-4fb3bd3956d5	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
6374c80e-22fd-4fab-9e00-4951e7267bbb	2022-09-28 15:38:09.400458+00	2022-09-28 15:38:09.388175+00	bouncy-caterpillar	SCHEDULED	0	2022-09-30 13:48:26.804+00	2022-09-30 13:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T13:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	61147f6e-b02b-450f-bd0a-4ba8411d989d	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
79ae0ab5-6680-4b34-895e-8719a509d18f	2022-09-28 15:38:09.400473+00	2022-09-28 15:38:09.388175+00	coral-coyote	SCHEDULED	0	2022-09-30 14:48:26.804+00	2022-09-30 14:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T14:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5da0193a-db27-4778-bb54-24de8633feec	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
180a532c-1cea-44e5-af21-bdf02bd5d634	2022-09-28 15:38:09.400489+00	2022-09-28 15:38:09.388175+00	wakeful-pegasus	SCHEDULED	0	2022-09-30 15:48:26.804+00	2022-09-30 15:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T15:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	a63c73ff-3fd4-49e2-ab94-c39015445272	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
17943622-6f77-497a-923d-fa6daf560608	2022-09-28 15:38:09.400506+00	2022-09-28 15:38:09.388175+00	granite-degu	SCHEDULED	0	2022-09-30 16:48:26.804+00	2022-09-30 16:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T16:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	580a1acd-fbe3-41b1-b0f3-0bb23d151e2b	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
414ecc79-f98d-4801-8c5a-c4ea2ca3f83b	2022-09-28 15:38:09.400523+00	2022-09-28 15:38:09.388175+00	fluorescent-ermine	SCHEDULED	0	2022-09-30 17:48:26.804+00	2022-09-30 17:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T17:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	dd86a087-ff84-4b76-b0e0-89829e2ecccf	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
35acce6f-1555-4620-abd5-fb31a02948b3	2022-09-28 15:38:09.40054+00	2022-09-28 15:38:09.388175+00	modest-llama	SCHEDULED	0	2022-09-30 18:48:26.804+00	2022-09-30 18:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T18:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	432f0869-f0c1-4c6a-a9e7-2b642c67d489	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
011abbfb-05db-4da4-9e4b-16211bf63a0e	2022-09-28 15:38:09.400558+00	2022-09-28 15:38:09.388175+00	prophetic-myna	SCHEDULED	0	2022-09-30 19:48:26.804+00	2022-09-30 19:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T19:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	c459d103-517e-447a-8787-1c3bd9fc56da	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
69c44735-16ce-41ef-ae57-5bf169110f9d	2022-09-28 15:38:09.400574+00	2022-09-28 15:38:09.388175+00	adamant-ringtail	SCHEDULED	0	2022-09-30 20:48:26.804+00	2022-09-30 20:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T20:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ad35d0db-6233-44d4-b2e4-a62f8cae5e70	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
8dbd12d1-479c-4402-9e44-aebe02ad36b6	2022-09-28 15:38:09.400592+00	2022-09-28 15:38:09.388175+00	chirpy-dogfish	SCHEDULED	0	2022-09-30 21:48:26.804+00	2022-09-30 21:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T21:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	e21b3275-3baa-4a07-97a4-3e732eeebc1d	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
17e23c0b-a8d3-4bb7-bb87-b54d08c69606	2022-09-28 15:38:09.400608+00	2022-09-28 15:38:09.388175+00	weightless-tiger	SCHEDULED	0	2022-09-30 22:48:26.804+00	2022-09-30 22:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T22:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	e15f88c2-ac9a-4bbf-98b7-388da51b5f59	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
48b0ca51-aae8-4f35-99b7-089b5a67cd06	2022-09-28 15:38:09.400624+00	2022-09-28 15:38:09.388175+00	competent-junglefowl	SCHEDULED	0	2022-09-30 23:48:26.804+00	2022-09-30 23:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-09-30T23:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5c19564b-f4df-4c96-b675-bbc6b062df9b	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
d17d41dd-8957-4194-ac9e-42dd6a298112	2022-09-28 15:38:09.40064+00	2022-09-28 15:38:09.388175+00	humongous-alligator	SCHEDULED	0	2022-10-01 00:48:26.804+00	2022-10-01 00:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T00:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9765f2c2-eee2-45ef-b4ce-87ad24af2470	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
4073ad43-68ae-48e3-b72a-359282d6e5c6	2022-09-28 15:38:09.400657+00	2022-09-28 15:38:09.388175+00	frisky-kiwi	SCHEDULED	0	2022-10-01 01:48:26.804+00	2022-10-01 01:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T01:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ba5913bd-3860-4dc4-a931-1b72fdd4aae0	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
4ad45a45-9ec1-41ea-a312-58b16b80c6cd	2022-09-28 15:38:09.400673+00	2022-09-28 15:38:09.388175+00	astonishing-marmot	SCHEDULED	0	2022-10-01 02:48:26.804+00	2022-10-01 02:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T02:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	6e1591ac-27d8-4482-938d-8a4124972ede	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
84907af1-1ae0-4326-90f4-67a4702f3102	2022-09-28 15:38:09.400689+00	2022-09-28 15:38:09.388175+00	brown-ibis	SCHEDULED	0	2022-10-01 03:48:26.804+00	2022-10-01 03:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T03:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	cc5c7e82-3ded-4d58-b497-765853c7b9cd	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
6f0f77fe-886d-48a4-9cae-8e83e17c211e	2022-09-28 15:38:09.400706+00	2022-09-28 15:38:09.388175+00	cute-owl	SCHEDULED	0	2022-10-01 04:48:26.804+00	2022-10-01 04:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T04:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	393e56f6-e815-4a5a-a617-dd3467c19c5f	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
3e5b7a2d-73f3-44eb-bd20-efa6dfbf26b0	2022-09-28 15:38:09.400723+00	2022-09-28 15:38:09.388175+00	uncovered-ara	SCHEDULED	0	2022-10-01 05:48:26.804+00	2022-10-01 05:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T05:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5ed37ace-1303-4f6b-b517-3f8e48be3b67	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
dada0e65-ab54-4150-bc8e-07ddbaa026b9	2022-09-28 15:38:09.400739+00	2022-09-28 15:38:09.388175+00	witty-python	SCHEDULED	0	2022-10-01 06:48:26.804+00	2022-10-01 06:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T06:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	e948a561-ebf6-4034-87db-e63d6f234e08	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
7e7176ca-3370-4e2e-8926-4720ad79d038	2022-09-28 15:38:09.400754+00	2022-09-28 15:38:09.388175+00	sapphire-echidna	SCHEDULED	0	2022-10-01 07:48:26.804+00	2022-10-01 07:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T07:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	4efffe62-98a7-4a01-a9f8-f81be3651f1a	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
adc802c9-70ef-4cc8-b231-95b59476a8ba	2022-09-28 15:38:09.400771+00	2022-09-28 15:38:09.388175+00	ruby-ammonite	SCHEDULED	0	2022-10-01 08:48:26.804+00	2022-10-01 08:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T08:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	c86071f0-138a-4c04-9c5f-3a9b4199c590	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
906b8d6e-f713-444f-b7c7-23383c0fa733	2022-09-28 15:38:09.400787+00	2022-09-28 15:38:09.388175+00	practical-civet	SCHEDULED	0	2022-10-01 09:48:26.804+00	2022-10-01 09:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T09:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	54ed9dc4-26d6-480c-9326-481ab872337e	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
0b8f5b0b-0e51-4c68-9a11-eeab9724e861	2022-09-28 15:38:09.400804+00	2022-09-28 15:38:09.388175+00	discerning-kingfisher	SCHEDULED	0	2022-10-01 10:48:26.804+00	2022-10-01 10:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T10:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ba252b6f-0511-4e22-b501-81d4c65f8ac3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
20046d4a-7fef-4e7b-beb5-138d8e67b99e	2022-09-28 15:38:09.400819+00	2022-09-28 15:38:09.388175+00	groovy-kittiwake	SCHEDULED	0	2022-10-01 11:48:26.804+00	2022-10-01 11:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T11:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9cfbefef-2dc2-467d-9b7b-f0c97508f1bf	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
372b3ea1-5408-486f-a9a8-27d99342d315	2022-09-28 15:38:09.400838+00	2022-09-28 15:38:09.388175+00	invisible-mantis	SCHEDULED	0	2022-10-01 12:48:26.804+00	2022-10-01 12:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T12:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	876b5e36-ef44-454b-8127-ff1fa8b6c4d3	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
458e41f7-72a0-4eb9-a550-38a399d66dd7	2022-09-28 15:38:09.400854+00	2022-09-28 15:38:09.388175+00	adorable-ara	SCHEDULED	0	2022-10-01 13:48:26.804+00	2022-10-01 13:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T13:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d7d74e14-47e4-4292-8b24-355cb23f1408	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
922b3de7-1483-416d-ad9d-ab0d111257dc	2022-09-28 15:38:09.40087+00	2022-09-28 15:38:09.388175+00	realistic-dinosaur	SCHEDULED	0	2022-10-01 14:48:26.804+00	2022-10-01 14:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T14:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	90799c5d-12f3-4264-8767-f1d3950f0b02	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
a069a875-fad1-43c9-816a-5e15a95522d6	2022-09-28 15:38:09.400886+00	2022-09-28 15:38:09.388175+00	wonderful-ara	SCHEDULED	0	2022-10-01 15:48:26.804+00	2022-10-01 15:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T15:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d26f6999-b1e5-4057-8201-448b9d2a9205	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
c2f7425e-c90d-4870-bd5e-e9467d1c4989	2022-09-28 15:38:09.400902+00	2022-09-28 15:38:09.388175+00	charcoal-mustang	SCHEDULED	0	2022-10-01 16:48:26.804+00	2022-10-01 16:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T16:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	14692887-3d1d-46ef-a7ed-4de10a1a2183	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
09f94802-98f0-4419-8435-2f4a85d8b362	2022-09-28 15:38:09.400918+00	2022-09-28 15:38:09.388175+00	private-cat	SCHEDULED	0	2022-10-01 17:48:26.804+00	2022-10-01 17:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T17:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	64bed05a-d153-4b35-af59-5c203f9901fc	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
19a02d2e-b2ea-4b85-9dc4-67a0190fb2f1	2022-09-28 15:38:09.400934+00	2022-09-28 15:38:09.388175+00	pastel-agama	SCHEDULED	0	2022-10-01 18:48:26.804+00	2022-10-01 18:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T18:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	9e967199-d7f2-4bd4-b8cc-8c333bbe4efb	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
586824e9-3330-492d-843d-7007b278c5a8	2022-09-28 15:38:09.40095+00	2022-09-28 15:38:09.388175+00	garrulous-raccoon	SCHEDULED	0	2022-10-01 19:48:26.804+00	2022-10-01 19:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T19:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	42717355-288c-4b36-8960-2e53523c375f	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
6fb711b5-3086-42a4-9ef6-a4ddfd14e6f4	2022-09-28 15:38:09.400967+00	2022-09-28 15:38:09.388175+00	jasper-mandrill	SCHEDULED	0	2022-10-01 20:48:26.804+00	2022-10-01 20:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T20:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	36cf347d-0c63-4420-9766-4eaa13016440	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
9502f684-6a41-4bf1-8e18-94ac8d59541f	2022-09-28 15:38:09.400983+00	2022-09-28 15:38:09.388175+00	eccentric-groundhog	SCHEDULED	0	2022-10-01 21:48:26.804+00	2022-10-01 21:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T21:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	1bfbc182-5768-495b-8ae3-3b2f20279be2	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
81f3502a-2d99-4c0d-83a7-10842f24ca5e	2022-09-28 15:38:09.400999+00	2022-09-28 15:38:09.388175+00	lush-squid	SCHEDULED	0	2022-10-01 22:48:26.804+00	2022-10-01 22:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T22:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	7b216fc7-1ea3-4f22-b85d-b683c8543556	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
88272ddc-809e-45f8-b328-4f2d60a3f8c1	2022-09-28 15:38:09.401015+00	2022-09-28 15:38:09.388175+00	rugged-grouse	SCHEDULED	0	2022-10-01 23:48:26.804+00	2022-10-01 23:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-01T23:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	5c858ace-9a91-46e5-8a86-cbac5622fd2a	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
6e910509-97b0-47e4-ac05-094928bef7e4	2022-09-28 15:38:09.401031+00	2022-09-28 15:38:09.388175+00	ebony-goshawk	SCHEDULED	0	2022-10-02 00:48:26.804+00	2022-10-02 00:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T00:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	89a681ab-ce24-429f-bdc4-36b9e37981e0	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
3b6ce95d-a39e-4975-847c-92d658c98774	2022-09-28 15:38:09.401101+00	2022-09-28 15:38:09.388175+00	magnetic-ocelot	SCHEDULED	0	2022-10-02 01:48:26.804+00	2022-10-02 01:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T01:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	4ad3e48e-25bd-4080-a66d-fac107ef6076	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
b842ed30-7658-493f-95f5-25b36cdef0ae	2022-09-28 15:38:09.401217+00	2022-09-28 15:38:09.388175+00	lively-piculet	SCHEDULED	0	2022-10-02 08:48:26.804+00	2022-10-02 08:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T08:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	ae41c2b1-601f-43e8-a051-4e4bcbbf4d67	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
03f5534e-a810-45c7-982f-919e53a0c43b	2022-09-28 15:38:09.401233+00	2022-09-28 15:38:09.388175+00	practical-numbat	SCHEDULED	0	2022-10-02 09:48:26.804+00	2022-10-02 09:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T09:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	3a2ae195-c0b0-4b99-82a6-2cf86bef8bbe	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
341a1834-a473-4071-beb1-cf8b2393fd8e	2022-09-28 15:38:09.401249+00	2022-09-28 15:38:09.388175+00	warm-lorikeet	SCHEDULED	0	2022-10-02 10:48:26.804+00	2022-10-02 10:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T10:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	29a7dbc2-516f-4404-8665-19239130bb08	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
9eb8ff36-afd4-4d0b-899e-1c8ea5ac7e39	2022-09-28 15:38:09.401265+00	2022-09-28 15:38:09.388175+00	wondrous-sambar	SCHEDULED	0	2022-10-02 11:48:26.804+00	2022-10-02 11:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T11:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	0bf1dc5f-2bb2-4938-8485-5f725bb32833	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
10b342ba-2f93-4779-93ae-c78229b02e5b	2022-09-28 15:38:09.401281+00	2022-09-28 15:38:09.388175+00	adventurous-markhor	SCHEDULED	0	2022-10-02 12:48:26.804+00	2022-10-02 12:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T12:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	adeb6e26-39b4-4ad0-b0b3-1bd9f281aaab	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
2264c8a1-cbf4-45c3-b5ad-2bb2884b2942	2022-09-28 15:38:09.401297+00	2022-09-28 15:38:09.388175+00	fragrant-groundhog	SCHEDULED	0	2022-10-02 13:48:26.804+00	2022-10-02 13:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T13:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	d8775b23-f690-4ce6-a634-6034ec0dd216	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
72efaaa6-7ef8-4623-a33c-3122de112081	2022-09-28 15:38:09.401378+00	2022-09-28 15:38:09.388175+00	fragrant-mastiff	SCHEDULED	0	2022-10-02 18:48:26.804+00	2022-10-02 18:48:26.804+00	\N	\N	00:00:00	\N	{}	scheduled 6cb560fe-0ad3-4f34-aa7a-d74f1f513155 2022-10-02T18:48:26.804000+00:00	{}	{"retries": null, "max_retries": 0, "retry_delay": null, "retry_delay_seconds": 0}	["auto-scheduled"]	t	567df184-ad88-471c-8a4b-d99024e39ca2	6cb560fe-0ad3-4f34-aa7a-d74f1f513155	\N	a2e4fd5d-b55b-4b5f-86d0-1d3d3fb2ed5c	Scheduled	6e8afe07-28d1-4e98-a930-c3074e5775ae	my_queue
\.


--
-- Data for Name: flow_run_notification_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow_run_notification_policy (id, created, updated, is_active, state_names, tags, message_template, block_document_id) FROM stdin;
\.


--
-- Data for Name: flow_run_notification_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow_run_notification_queue (id, created, updated, flow_run_notification_policy_id, flow_run_state_id) FROM stdin;
\.


--
-- Data for Name: flow_run_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow_run_state (id, created, updated, type, "timestamp", name, message, state_details, data, flow_run_id) FROM stdin;
91936d18-6986-4b8b-934b-4901b31cd5f6	2022-09-28 02:22:54.027693+00	2022-09-28 02:22:54.027714+00	SCHEDULED	2022-09-28 02:22:54.024042+00	Scheduled	Run from the Prefect UI with defaults	{"cache_key": null, "flow_run_id": "9db7dfc4-8866-4e70-bdc4-615371a66765", "task_run_id": null, "scheduled_time": "2022-09-28T02:22:54.021815+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9db7dfc4-8866-4e70-bdc4-615371a66765
6d86017b-1b69-4039-9a80-5a9a02f41ea3	2022-09-28 02:22:55.285273+00	2022-09-28 02:22:55.285284+00	PENDING	2022-09-28 02:22:55.281892+00	Pending	\N	{"cache_key": null, "flow_run_id": "9db7dfc4-8866-4e70-bdc4-615371a66765", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9db7dfc4-8866-4e70-bdc4-615371a66765
c74feb60-7475-4932-a533-b2d05b4988ec	2022-09-28 02:22:57.311634+00	2022-09-28 02:22:57.311646+00	RUNNING	2022-09-28 02:22:57.30747+00	Running	\N	{"cache_key": null, "flow_run_id": "9db7dfc4-8866-4e70-bdc4-615371a66765", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9db7dfc4-8866-4e70-bdc4-615371a66765
149c1daf-84fd-478c-8af7-be130bffd278	2022-09-28 02:22:57.386853+00	2022-09-28 02:22:57.386868+00	COMPLETED	2022-09-28 02:22:57.383615+00	Completed	\N	{"cache_key": null, "flow_run_id": "9db7dfc4-8866-4e70-bdc4-615371a66765", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"b4d8357eda5141a2af5d214daa581a87\\", \\"filesystem_document_id\\": \\"ea659451-1bda-40bb-9525-ded0167cc4d5\\"}", "encoding": "result"}	9db7dfc4-8866-4e70-bdc4-615371a66765
548f6614-a280-45f4-b6ef-0670253d22e1	2022-09-28 02:27:00.570851+00	2022-09-28 02:27:00.57087+00	SCHEDULED	2022-09-28 02:27:00.563822+00	Scheduled	Run from the Prefect UI with defaults	{"cache_key": null, "flow_run_id": "754157d4-6f3d-4c39-92ff-f0e750f916f4", "task_run_id": null, "scheduled_time": "2022-09-28T02:27:00.558909+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	754157d4-6f3d-4c39-92ff-f0e750f916f4
87708610-9377-485f-be54-3fedc31cf883	2022-09-28 02:27:01.079979+00	2022-09-28 02:27:01.079989+00	PENDING	2022-09-28 02:27:01.075754+00	Pending	\N	{"cache_key": null, "flow_run_id": "754157d4-6f3d-4c39-92ff-f0e750f916f4", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	754157d4-6f3d-4c39-92ff-f0e750f916f4
df48d4af-e0d1-4a52-9727-6df450679bf3	2022-09-28 02:27:02.42848+00	2022-09-28 02:27:02.428491+00	RUNNING	2022-09-28 02:27:02.425553+00	Running	\N	{"cache_key": null, "flow_run_id": "754157d4-6f3d-4c39-92ff-f0e750f916f4", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	754157d4-6f3d-4c39-92ff-f0e750f916f4
f375f214-f55d-43c7-8149-54e8e7b7ccbb	2022-09-28 02:27:02.48401+00	2022-09-28 02:27:02.484027+00	COMPLETED	2022-09-28 02:27:02.478996+00	Completed	\N	{"cache_key": null, "flow_run_id": "754157d4-6f3d-4c39-92ff-f0e750f916f4", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"d79ddacca59546ffb80bc2e6896e0738\\", \\"filesystem_document_id\\": \\"c298efa5-a65a-4160-b049-d00946e1ed3f\\"}", "encoding": "result"}	754157d4-6f3d-4c39-92ff-f0e750f916f4
249edb56-6b7d-43e7-8536-09ffc5d0a3e8	2022-09-28 02:30:28.536861+00	2022-09-28 02:30:28.536883+00	SCHEDULED	2022-09-28 02:30:28.52915+00	Scheduled	Run from the Prefect UI with defaults	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": null, "scheduled_time": "2022-09-28T02:30:28.526081+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	1390466b-f913-47cd-85ce-6b5c1000afb0
35a7c175-7844-40d3-bff8-43907f421905	2022-09-28 02:30:31.777457+00	2022-09-28 02:30:31.777468+00	PENDING	2022-09-28 02:30:31.774424+00	Pending	\N	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	1390466b-f913-47cd-85ce-6b5c1000afb0
c2c93bdd-88fd-458d-82a7-e27a0d7b77f1	2022-09-28 02:30:33.829104+00	2022-09-28 02:30:33.829126+00	RUNNING	2022-09-28 02:30:33.824044+00	Running	\N	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	1390466b-f913-47cd-85ce-6b5c1000afb0
12f8b1da-0c4d-4215-afd2-fb6cfa6631d5	2022-09-28 15:44:35.520777+00	2022-09-28 15:44:35.520791+00	RUNNING	2022-09-28 15:44:35.515562+00	Running	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a44524c8-7d21-4dfc-9478-54f7f083751e
484d4ec5-7fea-420f-9907-b76b61dafeee	2022-09-28 02:31:00.461616+00	2022-09-28 02:31:00.461629+00	COMPLETED	2022-09-28 02:31:00.457722+00	Completed	All states completed.	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"b15a7c92fa444fc8b701a6e6a5ea7bc3\\", \\"filesystem_document_id\\": \\"a09d06ec-f077-4e66-ab75-f1d3f2d2aec7\\"}", "encoding": "result"}	1390466b-f913-47cd-85ce-6b5c1000afb0
a8a69845-b502-4ae0-9702-5ed3cfb07a8d	2022-09-28 12:34:59.185813+00	2022-09-28 12:34:59.185836+00	SCHEDULED	2022-09-28 12:34:59.179433+00	Scheduled	Run from the Prefect UI with defaults	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": null, "scheduled_time": "2022-09-28T12:34:59.176367+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d9d33d26-e17d-4930-a659-1fc9b24c9142
899eeb3b-e1ed-454b-bf4e-4b91d03211e0	2022-09-28 12:35:04.099013+00	2022-09-28 12:35:04.099024+00	PENDING	2022-09-28 12:35:04.094229+00	Pending	\N	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d9d33d26-e17d-4930-a659-1fc9b24c9142
dcf6630d-404f-4854-82af-b5950a17e4f8	2022-09-28 12:35:05.552255+00	2022-09-28 12:35:05.552269+00	RUNNING	2022-09-28 12:35:05.547705+00	Running	\N	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d9d33d26-e17d-4930-a659-1fc9b24c9142
9c0ffab5-8bfd-4fd2-92c3-9e7b5c467456	2022-09-28 12:35:39.824774+00	2022-09-28 12:35:39.824786+00	COMPLETED	2022-09-28 12:35:39.820282+00	Completed	All states completed.	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"93b369f24e2e49cda5409f4f49676d7c\\", \\"filesystem_document_id\\": \\"019b0990-5aaf-408f-82ce-9e318f212918\\"}", "encoding": "result"}	d9d33d26-e17d-4930-a659-1fc9b24c9142
efc8463b-efb7-4b94-ae14-9a1e18ccd632	2022-09-28 15:49:08.148998+00	2022-09-28 15:49:08.14901+00	COMPLETED	2022-09-28 15:49:08.145159+00	Completed	All states completed.	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"f5bc243adc4f465fa2d819aa9d12d5bd\\", \\"filesystem_document_id\\": \\"ab0be542-6ad7-47b8-8570-422c482b1daa\\"}", "encoding": "result"}	3046a308-c64b-4a73-902a-a5546b6e5563
5d00ff0e-d204-4336-be06-53e60d68671f	2022-09-28 15:48:27.378839+00	2022-09-28 15:48:27.378961+00	RUNNING	2022-09-28 15:48:27.374574+00	Running	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3046a308-c64b-4a73-902a-a5546b6e5563
1683c6ac-6fb9-4143-8b4a-a93367c5b418	2022-09-28 15:48:48.268563+00	2022-09-28 15:48:48.268579+00	SCHEDULED	2022-09-28 15:48:48.239319+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T19:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	fec75f8e-b642-4085-98c1-660d6452f1fe
e9dbd5f9-186e-42ee-809d-f49818ebdd98	2022-09-28 15:38:09.432263+00	2022-09-28 15:38:09.432272+00	SCHEDULED	2022-09-28 15:38:09.391496+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T15:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3046a308-c64b-4a73-902a-a5546b6e5563
cc608db8-269d-4856-a8dd-4cc6afe3ca93	2022-09-28 15:38:09.432276+00	2022-09-28 15:38:09.432279+00	SCHEDULED	2022-09-28 15:38:09.391598+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T16:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d7781305-7fca-407a-a497-0dc8e1c464a2
10336ca6-ef4d-4086-b322-5c5c40f12806	2022-09-28 15:38:09.432283+00	2022-09-28 15:38:09.432286+00	SCHEDULED	2022-09-28 15:38:09.391667+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T17:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	98e7bc2d-cb52-4483-a5b5-c7b9e32bd2f4
ab125d03-5557-4d4d-bb44-919ed1e393d9	2022-09-28 15:38:09.432289+00	2022-09-28 15:38:09.432292+00	SCHEDULED	2022-09-28 15:38:09.391731+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T18:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	4b94fe49-d1cc-452f-ba8c-0f4e8de72652
3358c0ab-abf2-41bb-bc70-abeb8882a7c0	2022-09-28 15:38:09.432295+00	2022-09-28 15:38:09.432298+00	SCHEDULED	2022-09-28 15:38:09.391797+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T19:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	91045948-4c4c-45f6-a392-2786f9a3333d
67ce0833-e39c-43d0-8031-e1e285274631	2022-09-28 15:38:09.432301+00	2022-09-28 15:38:09.432304+00	SCHEDULED	2022-09-28 15:38:09.391861+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T20:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	321e659d-8ea5-464c-aa4a-c72f79af6e15
0aab9be7-519f-4250-9e95-51544ae265bc	2022-09-28 15:38:09.432307+00	2022-09-28 15:38:09.43231+00	SCHEDULED	2022-09-28 15:38:09.391923+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T21:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	5377ed90-fc91-4194-9b5d-0e1d2fef43eb
850df49a-3bf6-4ed8-8a29-19045533b494	2022-09-28 15:38:09.432313+00	2022-09-28 15:38:09.432316+00	SCHEDULED	2022-09-28 15:38:09.391984+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T22:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d6642e63-c00d-48f9-8c5c-2d3b606a8441
407d8f35-5113-4ed5-bf6a-27d5ef2e9d48	2022-09-28 15:38:09.432319+00	2022-09-28 15:38:09.432322+00	SCHEDULED	2022-09-28 15:38:09.392044+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-28T23:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a5ec91ba-edfc-4411-a0bf-7419a090323c
e2deaf27-5fdc-472f-b27d-c381e833a94c	2022-09-28 15:38:09.432325+00	2022-09-28 15:38:09.432328+00	SCHEDULED	2022-09-28 15:38:09.392104+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T00:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	833c9e40-bd33-4e19-96bb-e00faa904040
caa9a944-f30b-4960-bb9a-19084b2402a6	2022-09-28 15:38:09.432331+00	2022-09-28 15:38:09.432334+00	SCHEDULED	2022-09-28 15:38:09.392164+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T01:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	e7e6d989-0a75-46a6-914c-999d13a752e3
1a97050d-ef5e-4100-81c6-e5747398a216	2022-09-28 15:38:09.432337+00	2022-09-28 15:38:09.43234+00	SCHEDULED	2022-09-28 15:38:09.392224+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T02:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	1e0ac5e3-910c-45cd-bb35-6762842b2a0d
2119c3e8-daa0-4e34-836e-331f98e5dcfc	2022-09-28 15:38:09.432343+00	2022-09-28 15:38:09.432346+00	SCHEDULED	2022-09-28 15:38:09.392284+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T03:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	f7c0f281-d7a9-405d-98b7-7f12701a042f
0efe98c3-58e3-4f83-a22d-34269455b619	2022-09-28 15:38:09.432349+00	2022-09-28 15:38:09.432352+00	SCHEDULED	2022-09-28 15:38:09.392344+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T04:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	062334a9-1b2f-4c3c-b45c-0e0aaa6102bd
6265d72e-e99a-4c78-9fd7-fba2c69a9ec6	2022-09-28 15:38:09.432355+00	2022-09-28 15:38:09.432358+00	SCHEDULED	2022-09-28 15:38:09.392406+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T05:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	980e35f9-8c43-48f3-9c95-ed1f36303aa8
60cc2887-cc73-4cc4-8c34-db3944053286	2022-09-28 15:38:09.432361+00	2022-09-28 15:38:09.432364+00	SCHEDULED	2022-09-28 15:38:09.392466+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T06:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	cfa2ec9c-06ec-4fd7-899d-64f836642c7b
f42b54ac-01cc-4724-982e-41a589292c15	2022-09-28 15:38:09.432367+00	2022-09-28 15:38:09.43237+00	SCHEDULED	2022-09-28 15:38:09.392527+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T07:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	664771b2-bf16-4002-9dac-01019d7f6f0e
13ae6d84-5744-4fe3-b81d-37f74e3747dc	2022-09-28 15:38:09.432373+00	2022-09-28 15:38:09.432376+00	SCHEDULED	2022-09-28 15:38:09.392587+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T08:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	82d2924b-0d7a-4081-abe4-8b34b3c9e422
25a8a3b9-7059-430d-884b-fcc28fdb46a3	2022-09-28 15:38:09.432379+00	2022-09-28 15:38:09.432382+00	SCHEDULED	2022-09-28 15:38:09.39265+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T09:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	59b813b6-0803-4b50-8e9f-433dc87f91ea
5872b0b2-acfc-485d-81bf-cc48992a7edc	2022-09-28 15:38:09.432385+00	2022-09-28 15:38:09.432388+00	SCHEDULED	2022-09-28 15:38:09.392711+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T10:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	4d00d28e-2ab3-4a3b-80a6-01acb069530e
d1d69cd3-5ebc-44da-bf4b-030fa7f3a10e	2022-09-28 15:38:09.432391+00	2022-09-28 15:38:09.432394+00	SCHEDULED	2022-09-28 15:38:09.392774+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T11:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	226a01a6-1cea-4db1-91e2-915b25e24e02
40f1b358-178e-410e-8bb3-845f94d6d4db	2022-09-28 15:44:29.598984+00	2022-09-28 15:44:29.599005+00	SCHEDULED	2022-09-28 15:44:29.593357+00	Scheduled	Run from the Prefect UI with defaults	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": null, "scheduled_time": "2022-09-28T15:44:29.590122+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a44524c8-7d21-4dfc-9478-54f7f083751e
dadfaf36-75f1-48a7-a13c-8074040623c3	2022-09-28 15:45:28.467259+00	2022-09-28 15:45:28.467283+00	COMPLETED	2022-09-28 15:45:28.463615+00	Completed	All states completed.	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"abb0a4066b1c40358c62ab7b6570492e\\", \\"filesystem_document_id\\": \\"c3356fbf-7634-46f4-b6ec-0b0b8047ff80\\"}", "encoding": "result"}	a44524c8-7d21-4dfc-9478-54f7f083751e
1f56ac4e-9b08-4363-86e8-2e16aecc9995	2022-09-28 15:48:25.836151+00	2022-09-28 15:48:25.836162+00	PENDING	2022-09-28 15:48:25.833132+00	Pending	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3046a308-c64b-4a73-902a-a5546b6e5563
8bbcd45f-661f-4313-9e22-2886052a070f	2022-09-28 15:44:34.036241+00	2022-09-28 15:44:34.036252+00	PENDING	2022-09-28 15:44:34.031957+00	Pending	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": null, "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a44524c8-7d21-4dfc-9478-54f7f083751e
0743a14a-f899-496d-a18b-f35bf6e15d1d	2022-09-28 15:38:09.432397+00	2022-09-28 15:38:09.4324+00	SCHEDULED	2022-09-28 15:38:09.392859+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T12:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	f444c6da-3bca-417a-bfa1-4b917417a984
1b219b47-33db-48a4-983e-11cf6fe68430	2022-09-28 15:38:09.432403+00	2022-09-28 15:38:09.432406+00	SCHEDULED	2022-09-28 15:38:09.392923+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T13:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	dc9c9e7f-8f4a-4aee-bd65-92b842e5f4f3
acaf90e1-c779-4d59-a105-2af4fb5baf5c	2022-09-28 15:38:09.43241+00	2022-09-28 15:38:09.432413+00	SCHEDULED	2022-09-28 15:38:09.392985+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T14:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	e48fdebe-20ef-4f6a-8901-9f9684994998
298c7ce2-9869-481c-bb22-7cd30252635a	2022-09-28 15:38:09.432416+00	2022-09-28 15:38:09.432419+00	SCHEDULED	2022-09-28 15:38:09.393047+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T15:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	dc35dc1c-4356-43b5-a729-95aeebd90492
46c62b93-e4a4-4001-9907-5219e4bcdfaf	2022-09-28 15:38:09.432422+00	2022-09-28 15:38:09.432425+00	SCHEDULED	2022-09-28 15:38:09.393108+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T16:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	5ba4a63f-46ed-4007-8941-2cc493d250fc
2cbe914e-3f30-4a12-8e12-e79952e8e0e3	2022-09-28 15:38:09.432428+00	2022-09-28 15:38:09.432431+00	SCHEDULED	2022-09-28 15:38:09.393169+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T17:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	2c3b314b-5c20-46b1-826a-fec85688511f
19acb526-1807-4e9b-ad41-06d1d612b15c	2022-09-28 15:38:09.432434+00	2022-09-28 15:38:09.432437+00	SCHEDULED	2022-09-28 15:38:09.39323+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T18:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3a8ddad0-c43a-4f81-bfe7-0e0eee1d5266
a85bff08-74d5-4d9c-b38f-40f30a61bddb	2022-09-28 15:38:09.43244+00	2022-09-28 15:38:09.432443+00	SCHEDULED	2022-09-28 15:38:09.393292+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T19:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	f8f95285-401c-43c7-af16-858557fa57d6
c739c843-8d55-4b03-bb16-f9bc8e28dc00	2022-09-28 15:38:09.432446+00	2022-09-28 15:38:09.432449+00	SCHEDULED	2022-09-28 15:38:09.393352+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T20:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	545dc5c8-6a92-4e65-9e4b-2959139201db
ed3ab153-901a-427d-acf2-4f783c762bdd	2022-09-28 15:38:09.432452+00	2022-09-28 15:38:09.432455+00	SCHEDULED	2022-09-28 15:38:09.393412+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T21:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	df9ef155-cfb0-4df5-82b6-aa86b878d8b4
907a062f-1019-4374-8e35-45e14c10b72b	2022-09-28 15:38:09.432458+00	2022-09-28 15:38:09.432461+00	SCHEDULED	2022-09-28 15:38:09.393471+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T22:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	f2a302a1-094f-4191-9a0e-7ca399897fd9
976dea85-9fe5-4548-93a8-38fdf3f9604e	2022-09-28 15:38:09.432464+00	2022-09-28 15:38:09.432467+00	SCHEDULED	2022-09-28 15:38:09.393532+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-29T23:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d4f31bbb-b99a-436c-b5ca-995caa6a0db6
707eda69-b68d-4f49-bcb1-4013da9e38a6	2022-09-28 15:38:09.43247+00	2022-09-28 15:38:09.432473+00	SCHEDULED	2022-09-28 15:38:09.393593+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T00:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d3edc005-0642-44b6-ac2e-da7e3f48f1a8
20627ddc-1def-44ad-9123-7e28fd02fd8b	2022-09-28 15:38:09.432476+00	2022-09-28 15:38:09.432479+00	SCHEDULED	2022-09-28 15:38:09.393654+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T01:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	eaa01434-82c2-4080-a8b8-b9aaef6e4d19
6d267f0c-ae30-4327-a9ea-4daf0101248e	2022-09-28 15:38:09.432482+00	2022-09-28 15:38:09.432485+00	SCHEDULED	2022-09-28 15:38:09.393714+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T02:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	de0507ce-4f36-488d-aaff-5663a537a020
9cee5923-b8a3-43d3-af09-1d5ef6096c47	2022-09-28 15:38:09.432488+00	2022-09-28 15:38:09.432491+00	SCHEDULED	2022-09-28 15:38:09.393773+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T03:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	2173d6f3-8ac7-48f0-9c9b-38710e8a77e8
6ec158dc-07b5-46a1-93f7-0c8a3f202ad3	2022-09-28 15:38:09.432494+00	2022-09-28 15:38:09.432497+00	SCHEDULED	2022-09-28 15:38:09.393834+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T04:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	be5e4c6b-7848-44e6-aa3d-b890640e8a7f
a5f249e9-6a89-4169-9439-9df6b95fe743	2022-09-28 15:38:09.4325+00	2022-09-28 15:38:09.432503+00	SCHEDULED	2022-09-28 15:38:09.393893+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T05:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	b5bcdf2f-6d82-45f9-90e2-9e57e16ad017
2895f808-64a1-4d85-8072-d6b84f16a859	2022-09-28 15:38:09.432506+00	2022-09-28 15:38:09.432509+00	SCHEDULED	2022-09-28 15:38:09.393946+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T06:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	e476bf48-4e7b-4c8e-ab76-70f0eb760c10
34fa97ed-d23c-4a96-b509-1eab50349025	2022-09-28 15:38:09.432512+00	2022-09-28 15:38:09.432515+00	SCHEDULED	2022-09-28 15:38:09.394001+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T07:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	ae00e9b0-153c-46a4-9a04-e29206abe969
b958579e-a5fc-474c-8a13-e604dc38d2e3	2022-09-28 15:38:09.432518+00	2022-09-28 15:38:09.432521+00	SCHEDULED	2022-09-28 15:38:09.394056+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T08:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	881bce4d-2854-4bfb-b361-4b94d01d2756
1ea6a192-4f36-4d83-9b49-851604441192	2022-09-28 15:38:09.432524+00	2022-09-28 15:38:09.432527+00	SCHEDULED	2022-09-28 15:38:09.394178+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T09:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	36bc6f2a-87fc-4ab1-88e7-898ed1a9dfcb
5975d381-b696-4b5e-bd47-1ba09d19e018	2022-09-28 15:38:09.43253+00	2022-09-28 15:38:09.432533+00	SCHEDULED	2022-09-28 15:38:09.394271+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T10:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	8206875a-8cb6-4568-814c-aff2e73096f5
a0ccc029-d379-492b-8fc6-462ad99f397a	2022-09-28 15:38:09.432536+00	2022-09-28 15:38:09.432539+00	SCHEDULED	2022-09-28 15:38:09.394338+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T11:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	4fb31268-cf39-49f0-9b00-b9138e80b9bb
d2c6f6df-2dde-4cbd-9fc6-4fb3bd3956d5	2022-09-28 15:38:09.432542+00	2022-09-28 15:38:09.432545+00	SCHEDULED	2022-09-28 15:38:09.394401+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T12:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	fce080a2-709e-4307-b8d4-668dbf364dcd
61147f6e-b02b-450f-bd0a-4ba8411d989d	2022-09-28 15:38:09.432548+00	2022-09-28 15:38:09.432551+00	SCHEDULED	2022-09-28 15:38:09.394473+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T13:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6374c80e-22fd-4fab-9e00-4951e7267bbb
5da0193a-db27-4778-bb54-24de8633feec	2022-09-28 15:38:09.432554+00	2022-09-28 15:38:09.432557+00	SCHEDULED	2022-09-28 15:38:09.394545+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T14:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	79ae0ab5-6680-4b34-895e-8719a509d18f
a63c73ff-3fd4-49e2-ab94-c39015445272	2022-09-28 15:38:09.43256+00	2022-09-28 15:38:09.432563+00	SCHEDULED	2022-09-28 15:38:09.394606+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T15:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	180a532c-1cea-44e5-af21-bdf02bd5d634
580a1acd-fbe3-41b1-b0f3-0bb23d151e2b	2022-09-28 15:38:09.432566+00	2022-09-28 15:38:09.432569+00	SCHEDULED	2022-09-28 15:38:09.394666+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T16:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	17943622-6f77-497a-923d-fa6daf560608
dd86a087-ff84-4b76-b0e0-89829e2ecccf	2022-09-28 15:38:09.432572+00	2022-09-28 15:38:09.432575+00	SCHEDULED	2022-09-28 15:38:09.394747+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T17:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	414ecc79-f98d-4801-8c5a-c4ea2ca3f83b
432f0869-f0c1-4c6a-a9e7-2b642c67d489	2022-09-28 15:38:09.432578+00	2022-09-28 15:38:09.432581+00	SCHEDULED	2022-09-28 15:38:09.394819+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T18:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	35acce6f-1555-4620-abd5-fb31a02948b3
c459d103-517e-447a-8787-1c3bd9fc56da	2022-09-28 15:38:09.432584+00	2022-09-28 15:38:09.432587+00	SCHEDULED	2022-09-28 15:38:09.394879+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T19:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	011abbfb-05db-4da4-9e4b-16211bf63a0e
ad35d0db-6233-44d4-b2e4-a62f8cae5e70	2022-09-28 15:38:09.43259+00	2022-09-28 15:38:09.432593+00	SCHEDULED	2022-09-28 15:38:09.394939+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T20:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	69c44735-16ce-41ef-ae57-5bf169110f9d
e21b3275-3baa-4a07-97a4-3e732eeebc1d	2022-09-28 15:38:09.432596+00	2022-09-28 15:38:09.432599+00	SCHEDULED	2022-09-28 15:38:09.394999+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T21:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	8dbd12d1-479c-4402-9e44-aebe02ad36b6
e15f88c2-ac9a-4bbf-98b7-388da51b5f59	2022-09-28 15:38:09.432603+00	2022-09-28 15:38:09.432606+00	SCHEDULED	2022-09-28 15:38:09.395059+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T22:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	17e23c0b-a8d3-4bb7-bb87-b54d08c69606
5c19564b-f4df-4c96-b675-bbc6b062df9b	2022-09-28 15:38:09.432609+00	2022-09-28 15:38:09.432612+00	SCHEDULED	2022-09-28 15:38:09.395119+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-09-30T23:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	48b0ca51-aae8-4f35-99b7-089b5a67cd06
9765f2c2-eee2-45ef-b4ce-87ad24af2470	2022-09-28 15:38:09.432615+00	2022-09-28 15:38:09.432618+00	SCHEDULED	2022-09-28 15:38:09.39518+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T00:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	d17d41dd-8957-4194-ac9e-42dd6a298112
ba5913bd-3860-4dc4-a931-1b72fdd4aae0	2022-09-28 15:38:09.432621+00	2022-09-28 15:38:09.432624+00	SCHEDULED	2022-09-28 15:38:09.395239+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T01:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	4073ad43-68ae-48e3-b72a-359282d6e5c6
6e1591ac-27d8-4482-938d-8a4124972ede	2022-09-28 15:38:09.432627+00	2022-09-28 15:38:09.43263+00	SCHEDULED	2022-09-28 15:38:09.395299+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T02:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	4ad45a45-9ec1-41ea-a312-58b16b80c6cd
cc5c7e82-3ded-4d58-b497-765853c7b9cd	2022-09-28 15:38:09.432633+00	2022-09-28 15:38:09.432636+00	SCHEDULED	2022-09-28 15:38:09.395395+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T03:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	84907af1-1ae0-4326-90f4-67a4702f3102
393e56f6-e815-4a5a-a617-dd3467c19c5f	2022-09-28 15:38:09.432639+00	2022-09-28 15:38:09.432642+00	SCHEDULED	2022-09-28 15:38:09.395456+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T04:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6f0f77fe-886d-48a4-9cae-8e83e17c211e
5ed37ace-1303-4f6b-b517-3f8e48be3b67	2022-09-28 15:38:09.432645+00	2022-09-28 15:38:09.432648+00	SCHEDULED	2022-09-28 15:38:09.395518+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T05:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3e5b7a2d-73f3-44eb-bd20-efa6dfbf26b0
e948a561-ebf6-4034-87db-e63d6f234e08	2022-09-28 15:38:09.432651+00	2022-09-28 15:38:09.432654+00	SCHEDULED	2022-09-28 15:38:09.395578+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T06:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	dada0e65-ab54-4150-bc8e-07ddbaa026b9
4efffe62-98a7-4a01-a9f8-f81be3651f1a	2022-09-28 15:38:09.432657+00	2022-09-28 15:38:09.43266+00	SCHEDULED	2022-09-28 15:38:09.395637+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T07:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	7e7176ca-3370-4e2e-8926-4720ad79d038
c86071f0-138a-4c04-9c5f-3a9b4199c590	2022-09-28 15:38:09.432663+00	2022-09-28 15:38:09.432666+00	SCHEDULED	2022-09-28 15:38:09.395696+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T08:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	adc802c9-70ef-4cc8-b231-95b59476a8ba
54ed9dc4-26d6-480c-9326-481ab872337e	2022-09-28 15:38:09.432669+00	2022-09-28 15:38:09.432672+00	SCHEDULED	2022-09-28 15:38:09.395756+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T09:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	906b8d6e-f713-444f-b7c7-23383c0fa733
ba252b6f-0511-4e22-b501-81d4c65f8ac3	2022-09-28 15:38:09.432676+00	2022-09-28 15:38:09.432678+00	SCHEDULED	2022-09-28 15:38:09.395817+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T10:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	0b8f5b0b-0e51-4c68-9a11-eeab9724e861
9cfbefef-2dc2-467d-9b7b-f0c97508f1bf	2022-09-28 15:38:09.432682+00	2022-09-28 15:38:09.432684+00	SCHEDULED	2022-09-28 15:38:09.395878+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T11:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	20046d4a-7fef-4e7b-beb5-138d8e67b99e
876b5e36-ef44-454b-8127-ff1fa8b6c4d3	2022-09-28 15:38:09.432688+00	2022-09-28 15:38:09.43269+00	SCHEDULED	2022-09-28 15:38:09.395939+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T12:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	372b3ea1-5408-486f-a9a8-27d99342d315
d7d74e14-47e4-4292-8b24-355cb23f1408	2022-09-28 15:38:09.432694+00	2022-09-28 15:38:09.432696+00	SCHEDULED	2022-09-28 15:38:09.395998+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T13:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	458e41f7-72a0-4eb9-a550-38a399d66dd7
90799c5d-12f3-4264-8767-f1d3950f0b02	2022-09-28 15:38:09.4327+00	2022-09-28 15:38:09.432703+00	SCHEDULED	2022-09-28 15:38:09.396063+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T14:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	922b3de7-1483-416d-ad9d-ab0d111257dc
d26f6999-b1e5-4057-8201-448b9d2a9205	2022-09-28 15:38:09.432706+00	2022-09-28 15:38:09.432709+00	SCHEDULED	2022-09-28 15:38:09.396122+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T15:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a069a875-fad1-43c9-816a-5e15a95522d6
14692887-3d1d-46ef-a7ed-4de10a1a2183	2022-09-28 15:38:09.432712+00	2022-09-28 15:38:09.432715+00	SCHEDULED	2022-09-28 15:38:09.396181+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T16:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	c2f7425e-c90d-4870-bd5e-e9467d1c4989
64bed05a-d153-4b35-af59-5c203f9901fc	2022-09-28 15:38:09.432718+00	2022-09-28 15:38:09.432721+00	SCHEDULED	2022-09-28 15:38:09.39624+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T17:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	09f94802-98f0-4419-8435-2f4a85d8b362
9e967199-d7f2-4bd4-b8cc-8c333bbe4efb	2022-09-28 15:38:09.432724+00	2022-09-28 15:38:09.432727+00	SCHEDULED	2022-09-28 15:38:09.396298+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T18:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	19a02d2e-b2ea-4b85-9dc4-67a0190fb2f1
42717355-288c-4b36-8960-2e53523c375f	2022-09-28 15:38:09.43273+00	2022-09-28 15:38:09.432733+00	SCHEDULED	2022-09-28 15:38:09.396356+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T19:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	586824e9-3330-492d-843d-7007b278c5a8
36cf347d-0c63-4420-9766-4eaa13016440	2022-09-28 15:38:09.432736+00	2022-09-28 15:38:09.432739+00	SCHEDULED	2022-09-28 15:38:09.396416+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T20:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6fb711b5-3086-42a4-9ef6-a4ddfd14e6f4
1bfbc182-5768-495b-8ae3-3b2f20279be2	2022-09-28 15:38:09.432742+00	2022-09-28 15:38:09.432745+00	SCHEDULED	2022-09-28 15:38:09.396474+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T21:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9502f684-6a41-4bf1-8e18-94ac8d59541f
7b216fc7-1ea3-4f22-b85d-b683c8543556	2022-09-28 15:38:09.432748+00	2022-09-28 15:38:09.432751+00	SCHEDULED	2022-09-28 15:38:09.396532+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T22:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	81f3502a-2d99-4c0d-83a7-10842f24ca5e
5c858ace-9a91-46e5-8a86-cbac5622fd2a	2022-09-28 15:38:09.432754+00	2022-09-28 15:38:09.432757+00	SCHEDULED	2022-09-28 15:38:09.397239+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-01T23:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	88272ddc-809e-45f8-b328-4f2d60a3f8c1
89a681ab-ce24-429f-bdc4-36b9e37981e0	2022-09-28 15:38:09.43276+00	2022-09-28 15:38:09.432763+00	SCHEDULED	2022-09-28 15:38:09.397316+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T00:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6e910509-97b0-47e4-ac05-094928bef7e4
4ad3e48e-25bd-4080-a66d-fac107ef6076	2022-09-28 15:38:09.432766+00	2022-09-28 15:38:09.432769+00	SCHEDULED	2022-09-28 15:38:09.397378+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T01:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3b6ce95d-a39e-4975-847c-92d658c98774
e3914460-a151-492a-ab7a-58c595428371	2022-09-28 15:38:09.432772+00	2022-09-28 15:38:09.432775+00	SCHEDULED	2022-09-28 15:38:09.397435+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T02:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	79dc1173-4f6c-42ec-82b8-423a132ee7d7
4928a04c-5a1f-4cf2-958b-fb052f8ecf21	2022-09-28 15:38:09.432778+00	2022-09-28 15:38:09.432781+00	SCHEDULED	2022-09-28 15:38:09.397492+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T03:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	027eed8a-4522-4630-b3ca-f59e442efb3e
179a5de3-ca28-4b9e-826a-9cfa3baf47b8	2022-09-28 15:38:09.432784+00	2022-09-28 15:38:09.432787+00	SCHEDULED	2022-09-28 15:38:09.397547+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T04:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	46daa6c5-cd2e-4ad5-b743-4803535548b4
f7afe3f3-8622-4ac7-8e27-5d47d7981457	2022-09-28 15:38:09.43279+00	2022-09-28 15:38:09.432793+00	SCHEDULED	2022-09-28 15:38:09.397602+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T05:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	95d52758-5476-4ba4-845f-c72ac2dcb9b4
3e55c54f-dd27-48f7-815f-a97b466c6e24	2022-09-28 15:38:09.432796+00	2022-09-28 15:38:09.432799+00	SCHEDULED	2022-09-28 15:38:09.39766+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T06:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	971d3cf0-1423-4f92-a136-047fd6a5fbdf
09bd9b25-a0ed-494c-becd-aa0b38c97366	2022-09-28 15:38:09.432802+00	2022-09-28 15:38:09.432805+00	SCHEDULED	2022-09-28 15:38:09.397718+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T07:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a80db1d7-3ab0-42a7-8c55-196242af59e8
ae41c2b1-601f-43e8-a051-4e4bcbbf4d67	2022-09-28 15:38:09.432808+00	2022-09-28 15:38:09.432811+00	SCHEDULED	2022-09-28 15:38:09.39778+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T08:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	b842ed30-7658-493f-95f5-25b36cdef0ae
3a2ae195-c0b0-4b99-82a6-2cf86bef8bbe	2022-09-28 15:38:09.432814+00	2022-09-28 15:38:09.432817+00	SCHEDULED	2022-09-28 15:38:09.397843+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T09:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	03f5534e-a810-45c7-982f-919e53a0c43b
29a7dbc2-516f-4404-8665-19239130bb08	2022-09-28 15:38:09.43282+00	2022-09-28 15:38:09.432823+00	SCHEDULED	2022-09-28 15:38:09.397906+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T10:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	341a1834-a473-4071-beb1-cf8b2393fd8e
0bf1dc5f-2bb2-4938-8485-5f725bb32833	2022-09-28 15:38:09.432826+00	2022-09-28 15:38:09.432829+00	SCHEDULED	2022-09-28 15:38:09.397969+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T11:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9eb8ff36-afd4-4d0b-899e-1c8ea5ac7e39
adeb6e26-39b4-4ad0-b0b3-1bd9f281aaab	2022-09-28 15:38:09.432832+00	2022-09-28 15:38:09.432835+00	SCHEDULED	2022-09-28 15:38:09.398032+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T12:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	10b342ba-2f93-4779-93ae-c78229b02e5b
d8775b23-f690-4ce6-a634-6034ec0dd216	2022-09-28 15:38:09.432838+00	2022-09-28 15:38:09.432841+00	SCHEDULED	2022-09-28 15:38:09.398099+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T13:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	2264c8a1-cbf4-45c3-b5ad-2bb2884b2942
3e586072-f4aa-4f17-b1ea-5d59801a85aa	2022-09-28 15:38:09.432844+00	2022-09-28 15:38:09.432847+00	SCHEDULED	2022-09-28 15:38:09.398161+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T14:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	07fe6e8a-0258-4d26-945e-65ac42dea9e6
d8c2f8e7-6007-4097-9f15-210d6a480e2c	2022-09-28 15:38:09.43285+00	2022-09-28 15:38:09.432853+00	SCHEDULED	2022-09-28 15:38:09.398221+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T15:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	044163ae-82fe-4039-abd3-a0908048f8b2
9f15091e-c4d5-4f74-8b85-dffa4027396e	2022-09-28 15:38:09.432856+00	2022-09-28 15:38:09.432859+00	SCHEDULED	2022-09-28 15:38:09.398279+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T16:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	9c07abb2-a0b0-49c5-a211-fb4e0c099798
d2cef1cc-2291-4b3a-95a1-cf1a3262ba08	2022-09-28 15:38:09.432862+00	2022-09-28 15:38:09.432865+00	SCHEDULED	2022-09-28 15:38:09.398338+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T17:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	ee4ba0cf-01c8-4309-89d8-0b267e2ef4af
a2e4fd5d-b55b-4b5f-86d0-1d3d3fb2ed5c	2022-09-28 15:38:09.432868+00	2022-09-28 15:38:09.432871+00	SCHEDULED	2022-09-28 15:38:09.398397+00	Scheduled	Flow run scheduled	{"cache_key": null, "flow_run_id": null, "task_run_id": null, "scheduled_time": "2022-10-02T18:48:26.804000+00:00", "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	72efaaa6-7ef8-4623-a33c-3122de112081
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log (id, created, updated, name, level, flow_run_id, task_run_id, message, "timestamp") FROM stdin;
9b290dd6-4f46-4231-a1f2-a3c59cb75149	2022-09-28 02:10:00.096147+00	2022-09-28 02:10:00.09616+00	prefect.flow_runs	40	bceaafb1-f459-4f4c-86cc-c1046bf49ea6	\N	Validation of flow parameters failed with error: SignatureMismatchError("Function expects parameters [] but was provided with parameters ['names']")\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 284, in retrieve_flow_then_begin_flow_run\n    parameters = flow.validate_parameters(flow_run.parameters)\n  File "/usr/local/lib/python3.10/site-packages/prefect/flows.py", line 262, in validate_parameters\n    args, kwargs = parameters_to_args_kwargs(self.fn, parameters)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/callables.py", line 53, in parameters_to_args_kwargs\n    raise SignatureMismatchError.from_bad_params(\nprefect.exceptions.SignatureMismatchError: Function expects parameters [] but was provided with parameters ['names']	2022-09-28 02:10:00.059683+00
5028f8c5-abcb-4fbd-8f1f-9b5ff6e6c5c1	2022-09-28 02:11:54.996161+00	2022-09-28 02:11:54.996185+00	prefect.flow_runs	20	0707e69f-16c4-4855-924c-65a090a17b50	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 02:11:54.88358+00
bd004fc9-9e9a-4b99-aaf5-063c7b5cd03c	2022-09-28 02:11:54.996196+00	2022-09-28 02:11:54.9962+00	prefect.flow_runs	20	0707e69f-16c4-4855-924c-65a090a17b50	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 02:11:54.884356+00
3ebe2559-f56c-48dd-890c-2b91abc40df5	2022-09-28 02:11:54.996208+00	2022-09-28 02:11:54.996212+00	prefect.task_runs	40	0707e69f-16c4-4855-924c-65a090a17b50	3e5b8b32-827c-42f8-8399-aa0ae283e91d	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 95, in trigger_sync\n    uuid.UUID(connection_id)\n  File "/usr/local/lib/python3.10/uuid.py", line 174, in __init__\n    hex = hex.replace('urn:', '').replace('uuid:', '')\nAttributeError: 'String' object has no attribute 'replace'	2022-09-28 02:11:54.918179+00
874275bb-1108-4797-9ffc-d1357382d99b	2022-09-28 02:11:54.99622+00	2022-09-28 02:11:54.996223+00	prefect.flow_runs	40	0707e69f-16c4-4855-924c-65a090a17b50	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 24, in main\n    airbyte_trigger_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 95, in trigger_sync\n    uuid.UUID(connection_id)\n  File "/usr/local/lib/python3.10/uuid.py", line 174, in __init__\n    hex = hex.replace('urn:', '').replace('uuid:', '')\nAttributeError: 'String' object has no attribute 'replace'	2022-09-28 02:11:54.949511+00
84628f9e-3e07-4eda-8ffe-260adc5672f5	2022-09-28 02:20:22.088006+00	2022-09-28 02:20:22.088024+00	prefect.flow_runs	20	de430e44-ad1a-47ab-9f18-99a71d35fdae	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 02:20:21.990307+00
b4aced88-8be4-4ff4-b85c-dd0d531a6d33	2022-09-28 02:20:22.088036+00	2022-09-28 02:20:22.088041+00	prefect.flow_runs	20	de430e44-ad1a-47ab-9f18-99a71d35fdae	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 02:20:21.991436+00
87707ec2-3fae-4118-9da0-8b9640ba47b9	2022-09-28 02:20:22.088049+00	2022-09-28 02:20:22.088054+00	prefect.task_runs	40	de430e44-ad1a-47ab-9f18-99a71d35fdae	a3c4dc0e-3938-4d20-a85d-bbd02abbd51d	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 95, in trigger_sync\n    uuid.UUID(connection_id)\n  File "/usr/local/lib/python3.10/uuid.py", line 174, in __init__\n    hex = hex.replace('urn:', '').replace('uuid:', '')\nAttributeError: 'String' object has no attribute 'replace'	2022-09-28 02:20:22.019315+00
4d1343a6-28ec-4ff8-8a69-5a920570ad1d	2022-09-28 02:20:22.088062+00	2022-09-28 02:20:22.088066+00	prefect.flow_runs	40	de430e44-ad1a-47ab-9f18-99a71d35fdae	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 22, in main\n    airbyte_trigger_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 95, in trigger_sync\n    uuid.UUID(connection_id)\n  File "/usr/local/lib/python3.10/uuid.py", line 174, in __init__\n    hex = hex.replace('urn:', '').replace('uuid:', '')\nAttributeError: 'String' object has no attribute 'replace'	2022-09-28 02:20:22.047081+00
6d77a683-39b6-4860-a457-6da28d893eb8	2022-09-28 02:30:35.913404+00	2022-09-28 02:30:35.913428+00	prefect.flow_runs	20	1390466b-f913-47cd-85ce-6b5c1000afb0	\N	run airbyte	2022-09-28 02:30:33.888898+00
7a3b10f2-6727-4d9c-b440-45f33f00eae5	2022-09-28 02:30:35.913442+00	2022-09-28 02:30:35.913448+00	prefect.flow_runs	20	1390466b-f913-47cd-85ce-6b5c1000afb0	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 02:30:33.91952+00
20f31766-f9bd-4c1d-b000-894d5bed1197	2022-09-28 02:30:35.913458+00	2022-09-28 02:30:35.913465+00	prefect.flow_runs	20	1390466b-f913-47cd-85ce-6b5c1000afb0	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 02:30:33.919926+00
6b645eac-81d6-4c57-b9c2-8f21c8ade1b7	2022-09-28 02:31:00.494052+00	2022-09-28 02:31:00.494077+00	prefect.flow_runs	20	1390466b-f913-47cd-85ce-6b5c1000afb0	\N	airbyte executed	2022-09-28 02:31:00.448108+00
af1a5b9d-d888-4695-9456-2bc0cf5496c1	2022-09-28 12:31:37.135522+00	2022-09-28 12:31:37.135537+00	prefect.flow_runs	20	a0c2644d-03dd-49b8-b9fb-616702ed0830	\N	run airbyte	2022-09-28 12:31:35.121742+00
9c680487-7668-41e3-99d1-7c88a55f18e6	2022-09-28 12:31:37.135547+00	2022-09-28 12:31:37.13555+00	prefect.flow_runs	20	a0c2644d-03dd-49b8-b9fb-616702ed0830	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 12:31:35.161016+00
cc40d995-fd88-4842-85c7-added2cf339c	2022-09-28 12:31:37.135558+00	2022-09-28 12:31:37.135562+00	prefect.flow_runs	20	a0c2644d-03dd-49b8-b9fb-616702ed0830	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 12:31:35.161304+00
f8d8073b-384f-41ae-8ed4-69ec7c77e0e9	2022-09-28 12:31:40.875044+00	2022-09-28 12:31:40.875056+00	prefect.task_runs	40	a0c2644d-03dd-49b8-b9fb-616702ed0830	6b269f2c-83f6-4b3f-92cc-d685b0e58426	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 12:31:40.797925+00
cc36a111-0dbc-4bcb-9f96-7a9195d12b3f	2022-09-28 12:33:17.32489+00	2022-09-28 12:33:17.324953+00	prefect.flow_runs	20	c5e9b061-2231-4757-9cb2-c2d4f87105e4	\N	run airbyte	2022-09-28 12:33:15.311556+00
c388fbdd-7d8d-4c51-935f-36ae03eae6bf	2022-09-28 12:33:17.324974+00	2022-09-28 12:33:17.32498+00	prefect.flow_runs	20	c5e9b061-2231-4757-9cb2-c2d4f87105e4	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 12:33:15.340235+00
dc22c4cb-38f1-40f2-a56f-540155d20136	2022-09-28 12:33:17.324994+00	2022-09-28 12:33:17.325002+00	prefect.flow_runs	20	c5e9b061-2231-4757-9cb2-c2d4f87105e4	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 12:33:15.34058+00
08a4e40c-15de-4872-b75d-656582e3263d	2022-09-28 12:35:07.634831+00	2022-09-28 12:35:07.634857+00	prefect.flow_runs	20	d9d33d26-e17d-4930-a659-1fc9b24c9142	\N	run airbyte	2022-09-28 12:35:05.608525+00
0168ef37-83b9-46b9-851f-37a2b919703f	2022-09-28 12:31:40.875065+00	2022-09-28 12:31:40.875069+00	prefect.flow_runs	40	a0c2644d-03dd-49b8-b9fb-616702ed0830	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 588, in orchestrate_flow_run\n    result = await flow_call()\n  File "/root/flows/example.py", line 24, in main\n    await airbyte_trigger_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 12:31:40.838062+00
b1408d8c-83db-4818-839b-0ed262d21c2a	2022-09-28 12:33:20.487071+00	2022-09-28 12:33:20.487083+00	prefect.task_runs	40	c5e9b061-2231-4757-9cb2-c2d4f87105e4	4519c920-250f-4351-9c10-a816a7378952	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 12:33:20.432674+00
eabf8955-54e0-4188-8610-048543744aa4	2022-09-28 12:33:20.487093+00	2022-09-28 12:33:20.487096+00	prefect.flow_runs	40	c5e9b061-2231-4757-9cb2-c2d4f87105e4	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 588, in orchestrate_flow_run\n    result = await flow_call()\n  File "/root/flows/example.py", line 24, in main\n    await airbyte_trigger_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 12:33:20.454585+00
c91dac3d-6ff8-4927-b188-4742a6866948	2022-09-28 12:35:07.634873+00	2022-09-28 12:35:07.634879+00	prefect.flow_runs	20	d9d33d26-e17d-4930-a659-1fc9b24c9142	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 12:35:05.638504+00
ff83b8bd-f22c-49af-a767-ef2cbb949ee9	2022-09-28 12:35:07.634889+00	2022-09-28 12:35:07.634923+00	prefect.flow_runs	20	d9d33d26-e17d-4930-a659-1fc9b24c9142	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 12:35:05.638885+00
088a8b25-ac14-4899-a425-bddb38769f7e	2022-09-28 12:35:39.843786+00	2022-09-28 12:35:39.843797+00	prefect.flow_runs	20	d9d33d26-e17d-4930-a659-1fc9b24c9142	\N	airbyte executed	2022-09-28 12:35:39.812729+00
2920ba21-cff3-4555-9b49-6defc6deba77	2022-09-28 14:48:46.051035+00	2022-09-28 14:48:46.051047+00	prefect.flow_runs	40	51455eb9-ab14-4cd9-b0db-f70ed32c44aa	\N	Flow could not be retrieved from deployment.\nTraceback (most recent call last):\n  File "<frozen importlib._bootstrap_external>", line 883, in exec_module\n  File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed\n  File "/root/flows/example.py", line 6, in <module>\n    from prefect_dbt.cli.commands import trigger_dbt_cli_command\nModuleNotFoundError: No module named 'prefect_dbt'\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 256, in retrieve_flow_then_begin_flow_run\n    flow = await load_flow_from_flow_run(flow_run, client=client)\n  File "/usr/local/lib/python3.10/site-packages/prefect/client.py", line 103, in with_injected_client\n    return await fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect/deployments.py", line 69, in load_flow_from_flow_run\n    flow = await run_sync_in_worker_thread(import_object, str(import_path))\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/importtools.py", line 193, in import_object\n    module = load_script_as_module(script_path)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/importtools.py", line 156, in load_script_as_module\n    raise ScriptError(user_exc=exc, path=path) from exc\nprefect.exceptions.ScriptError: Script at '/root/flows/example.py' encountered an exception	2022-09-28 14:48:46.003222+00
e563984e-0e99-437e-8f6d-f4bf126d01e9	2022-09-28 14:50:18.072229+00	2022-09-28 14:50:18.072289+00	prefect.flow_runs	20	77891eb3-574e-409c-ad2e-73517e6c20b8	\N	trigger airbyte sync	2022-09-28 14:50:16.052186+00
df85e25c-44b2-4ea0-9396-bcc94eff0834	2022-09-28 14:50:18.072304+00	2022-09-28 14:50:18.072309+00	prefect.flow_runs	20	77891eb3-574e-409c-ad2e-73517e6c20b8	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 14:50:16.104633+00
4fc50dd4-4e9d-43fa-89bc-945983f041d0	2022-09-28 14:50:18.072318+00	2022-09-28 14:50:18.072336+00	prefect.flow_runs	20	77891eb3-574e-409c-ad2e-73517e6c20b8	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 14:50:16.105015+00
1a9b6db0-eae8-4b38-8f6a-f2c29f091099	2022-09-28 14:50:21.66915+00	2022-09-28 14:50:21.669164+00	prefect.task_runs	40	77891eb3-574e-409c-ad2e-73517e6c20b8	373f29e0-2c87-4a32-a043-cac31be859a4	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 14:50:21.594338+00
59ada9f5-d70b-4a2a-8c51-0ac6e31d6034	2022-09-28 14:50:21.669173+00	2022-09-28 14:50:21.669177+00	prefect.flow_runs	40	77891eb3-574e-409c-ad2e-73517e6c20b8	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 33, in main\n    trigger_airbyte_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 14:50:21.626736+00
a29a85d1-9064-436b-9963-53f69852af59	2022-09-28 14:51:58.251197+00	2022-09-28 14:51:58.251209+00	prefect.flow_runs	20	c6c9dec0-ea1c-43d7-b5ab-a63c83989a03	\N	trigger airbyte sync	2022-09-28 14:51:56.238512+00
a198085e-74cd-48e2-aefc-f56874f1f07e	2022-09-28 14:51:58.251218+00	2022-09-28 14:51:58.251222+00	prefect.flow_runs	20	c6c9dec0-ea1c-43d7-b5ab-a63c83989a03	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 14:51:56.26426+00
b11e8079-9a4c-41d6-bf06-e51d55661788	2022-09-28 14:51:58.251229+00	2022-09-28 14:51:58.251233+00	prefect.flow_runs	20	c6c9dec0-ea1c-43d7-b5ab-a63c83989a03	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 14:51:56.264586+00
d9559779-8f98-4b2f-aeb4-31a607d8632c	2022-09-28 14:52:01.419859+00	2022-09-28 14:52:01.419872+00	prefect.task_runs	40	c6c9dec0-ea1c-43d7-b5ab-a63c83989a03	5dd45071-2f48-4e01-86a6-0a4941fff6fc	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 14:52:01.341148+00
c9165229-773b-4725-945d-6e6ebe4d659d	2022-09-28 14:58:09.122022+00	2022-09-28 14:58:09.122048+00	prefect.flow_runs	20	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	trigger airbyte sync	2022-09-28 14:58:07.103052+00
cd790ec3-c6e6-45ff-b7a2-7d4bb00650ba	2022-09-28 14:58:09.122065+00	2022-09-28 14:58:09.122071+00	prefect.flow_runs	20	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 14:58:07.130479+00
38e77324-6189-4476-9878-48445c469f06	2022-09-28 14:58:09.122081+00	2022-09-28 14:58:09.122087+00	prefect.flow_runs	20	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 14:58:07.130803+00
8b32c316-4770-4797-b6c9-c478eea0ba9a	2022-09-28 14:58:29.188792+00	2022-09-28 14:58:29.188804+00	prefect.flow_runs	20	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	airbyte sync executed	2022-09-28 14:58:29.156203+00
d47e6061-2eb0-4163-be75-72ff7c4ca21f	2022-09-28 14:58:29.188814+00	2022-09-28 14:58:29.188818+00	prefect.flow_runs	20	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	get postgres profile	2022-09-28 14:58:29.156534+00
36f537e9-174a-4c5b-806b-917b73f844a3	2022-09-28 15:38:31.353328+00	2022-09-28 15:38:31.353333+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:38:29.375953+00
0f6fb741-5689-47c9-8516-6417d333c751	2022-09-28 14:52:01.419882+00	2022-09-28 14:52:01.419885+00	prefect.flow_runs	40	c6c9dec0-ea1c-43d7-b5ab-a63c83989a03	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 33, in read\n    return await self._stream.receive(max_bytes=max_bytes)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 1265, in receive\n    await self._protocol.read_event.wait()\n  File "/usr/local/lib/python3.10/asyncio/locks.py", line 214, in wait\n    await fut\nasyncio.exceptions.CancelledError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 8, in map_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 31, in read\n    with anyio.fail_after(timeout):\n  File "/usr/local/lib/python3.10/site-packages/anyio/_core/_tasks.py", line 118, in __exit__\n    raise TimeoutError\nTimeoutError\n\nDuring handling of the above exception, another exception occurred:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 60, in map_httpcore_exceptions\n    yield\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 353, in handle_async_request\n    resp = await self._pool.handle_async_request(req)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 253, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection_pool.py", line 237, in handle_async_request\n    response = await connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/connection.py", line 90, in handle_async_request\n    return await self._connection.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 105, in handle_async_request\n    raise exc\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 84, in handle_async_request\n    ) = await self._receive_response_headers(**kwargs)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 148, in _receive_response_headers\n    event = await self._receive_event(timeout=timeout)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_async/http11.py", line 177, in _receive_event\n    data = await self._network_stream.read(\n  File "/usr/local/lib/python3.10/site-packages/httpcore/backends/asyncio.py", line 30, in read\n    with map_exceptions(exc_map):\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpcore/_exceptions.py", line 12, in map_exceptions\n    raise to_exc(exc)\nhttpcore.ReadTimeout\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 33, in main\n    trigger_airbyte_sync(\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/connections.py", line 120, in trigger_sync\n    job_id, job_created_at = await airbyte.trigger_manual_sync_connection(\n  File "/usr/local/lib/python3.10/site-packages/prefect_airbyte/client.py", line 158, in trigger_manual_sync_connection\n    response = await client.post(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1842, in post\n    return await self.request(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1527, in request\n    return await self.send(request, auth=auth, follow_redirects=follow_redirects)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1614, in send\n    response = await self._send_handling_auth(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1642, in _send_handling_auth\n    response = await self._send_handling_redirects(\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1679, in _send_handling_redirects\n    response = await self._send_single_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_client.py", line 1716, in _send_single_request\n    response = await transport.handle_async_request(request)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 352, in handle_async_request\n    with map_httpcore_exceptions():\n  File "/usr/local/lib/python3.10/contextlib.py", line 153, in __exit__\n    self.gen.throw(typ, value, traceback)\n  File "/usr/local/lib/python3.10/site-packages/httpx/_transports/default.py", line 77, in map_httpcore_exceptions\n    raise mapped_exc(message) from exc\nhttpx.ReadTimeout	2022-09-28 14:52:01.372511+00
92acb676-f526-4c4f-b023-0a2fd3bb7131	2022-09-28 14:58:29.188825+00	2022-09-28 14:58:29.188829+00	prefect.flow_runs	40	fdfd863d-d2ef-46ba-aadd-c6cb0d6edbaa	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 46, in main\n    username=postgres_connection.values['POSTGRES_USER'],\nAttributeError: 'JSON' object has no attribute 'values'	2022-09-28 14:58:29.156886+00
cbd88e62-6e91-46b0-9b2e-c1f8d68c07c7	2022-09-28 15:01:09.77435+00	2022-09-28 15:01:09.774362+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	trigger airbyte sync	2022-09-28 15:01:07.761495+00
4f0618be-9b43-40d1-abca-0e05c3a84d5d	2022-09-28 15:01:09.774371+00	2022-09-28 15:01:09.774374+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:01:07.790709+00
521d90ae-83c2-4f64-822f-8561b5a9f6ab	2022-09-28 15:01:09.774381+00	2022-09-28 15:01:09.774385+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:01:07.791028+00
34ced064-5d00-42c6-aa6c-73016bd7c21d	2022-09-28 15:01:39.807922+00	2022-09-28 15:01:39.807932+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	airbyte sync executed	2022-09-28 15:01:38.627059+00
2c9318b2-7033-4151-809a-d7092a973f00	2022-09-28 15:01:39.807941+00	2022-09-28 15:01:39.807945+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	get postgres profile	2022-09-28 15:01:38.627314+00
2d0d8a09-72cc-4428-b2ba-93858eaa8dc8	2022-09-28 15:01:39.807951+00	2022-09-28 15:01:39.807955+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	dbt deps	2022-09-28 15:01:38.627716+00
160c31d1-96ed-4a77-bc5b-b6db200dfe9c	2022-09-28 15:01:39.807961+00	2022-09-28 15:01:39.807964+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:01:38.644242+00
714fbb15-ec43-41f3-8b8f-62613fe0652b	2022-09-28 15:01:39.807971+00	2022-09-28 15:01:39.807974+00	prefect.flow_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:01:38.64454+00
8a803aef-d288-4230-a91a-b6c5becef935	2022-09-28 15:01:39.807981+00	2022-09-28 15:01:39.807985+00	prefect.task_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	a9f50fe6-ebec-47b5-9a29-2b291adbac46	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:01:38.669701+00
d956a72a-e0ea-46d2-a00e-b18649f8c22f	2022-09-28 15:01:39.807991+00	2022-09-28 15:01:39.807995+00	prefect.task_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	a9f50fe6-ebec-47b5-9a29-2b291adbac46	Running dbt command: dbt deps --profiles-dir /root/.dbt	2022-09-28 15:01:38.67+00
10f54fc7-2726-441d-9245-86a429fa2224	2022-09-28 15:01:41.444547+00	2022-09-28 15:01:41.444559+00	prefect.task_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	a9f50fe6-ebec-47b5-9a29-2b291adbac46	[0m15:01:41  Encountered an error:\nRuntime Error\n  fatal: Not a dbt project (or any of the parent directories). Missing dbt_project.yml file\n	2022-09-28 15:01:41.266145+00
935285ba-a2da-4b0b-9f6a-4a3e611b7c85	2022-09-28 15:01:41.444568+00	2022-09-28 15:01:41.444571+00	prefect.task_runs	20	7d772c84-f977-4924-87cc-e18b86583b19	a9f50fe6-ebec-47b5-9a29-2b291adbac46	[0m15:01:41  Traceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 129, in main\n    results, succeeded = handle_and_check(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 191, in handle_and_check\n    task, res = run_from_args(parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 218, in run_from_args\n    task = parsed.cls.from_args(args=parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/deps.py", line 90, in from_args\n    move_to_nearest_project_dir(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 171, in move_to_nearest_project_dir\n    nearest_project_dir = get_nearest_project_dir(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 164, in get_nearest_project_dir\n    raise dbt.exceptions.RuntimeException(\ndbt.exceptions.RuntimeException: Runtime Error\n  fatal: Not a dbt project (or any of the parent directories). Missing dbt_project.yml file\n\n	2022-09-28 15:01:41.268328+00
6ff0843d-02b8-4002-8466-08d10e6286a8	2022-09-28 15:01:41.444578+00	2022-09-28 15:01:41.444582+00	prefect.task_runs	40	7d772c84-f977-4924-87cc-e18b86583b19	a9f50fe6-ebec-47b5-9a29-2b291adbac46	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  fatal: Not a dbt project (or any of the parent directories). Missing dbt_project.yml file\n	2022-09-28 15:01:41.400392+00
08029d66-ea18-4bb5-9f65-d9e756fb580b	2022-09-28 15:01:41.444588+00	2022-09-28 15:01:41.444592+00	prefect.flow_runs	40	7d772c84-f977-4924-87cc-e18b86583b19	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 59, in main\n    trigger_dbt_cli_command("dbt deps", dbt_cli_profile=dbt_cli_profile)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  fatal: Not a dbt project (or any of the parent directories). Missing dbt_project.yml file\n	2022-09-28 15:01:41.417471+00
abd7000c-39ec-4411-b9cf-24146f15504b	2022-09-28 15:14:37.041639+00	2022-09-28 15:14:37.041651+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	trigger airbyte sync	2022-09-28 15:14:35.028508+00
b532a63c-7843-4438-85d9-63dcf9d19a30	2022-09-28 15:14:37.04166+00	2022-09-28 15:14:37.041664+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:14:35.060616+00
d6376196-a326-43ba-a57b-b3b757fd4556	2022-09-28 15:14:37.041671+00	2022-09-28 15:14:37.041674+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:14:35.060904+00
d696eae5-6016-4c4a-b0a5-3229c224b003	2022-09-28 15:15:08.942468+00	2022-09-28 15:15:08.942488+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	airbyte sync executed	2022-09-28 15:15:08.812985+00
0c3d852e-ceed-4594-82c5-001457ab17eb	2022-09-28 15:15:08.942498+00	2022-09-28 15:15:08.942502+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	get postgres profile	2022-09-28 15:15:08.813376+00
dbf2a63c-7229-4eb4-8529-b7977bbbde32	2022-09-28 15:15:08.94251+00	2022-09-28 15:15:08.942514+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	dbt deps	2022-09-28 15:15:08.813902+00
9f3d1ff5-f8eb-4947-a59c-d0d7089ce184	2022-09-28 15:15:08.942522+00	2022-09-28 15:15:08.942526+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:15:08.842001+00
907a7fe7-7422-4826-b958-bbee2e9c7a71	2022-09-28 15:15:08.942533+00	2022-09-28 15:15:08.942537+00	prefect.flow_runs	20	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:15:08.842416+00
5f4617bd-dbc3-49a9-beef-c3c9304955d8	2022-09-28 15:15:08.942544+00	2022-09-28 15:15:08.942548+00	prefect.task_runs	40	cb179647-6a8c-4568-8e80-2d46226d5b11	eda4f988-2da0-4984-acd0-a39ff3f682a8	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 142, in trigger_dbt_cli_command\n    raise ValueError(\nValueError: Since overwrite_profiles is False and profiles_path (/root/.dbt/profiles.yml) already exists, the profile within dbt_cli_profile could not be used; if the existing profile is satisfactory, do not pass dbt_cli_profile	2022-09-28 15:15:08.873031+00
0ba5d205-953b-49fe-a032-d5ad64d67c17	2022-09-28 15:15:08.942555+00	2022-09-28 15:15:08.942559+00	prefect.flow_runs	40	cb179647-6a8c-4568-8e80-2d46226d5b11	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 60, in main\n    trigger_dbt_cli_command("dbt deps", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 142, in trigger_dbt_cli_command\n    raise ValueError(\nValueError: Since overwrite_profiles is False and profiles_path (/root/.dbt/profiles.yml) already exists, the profile within dbt_cli_profile could not be used; if the existing profile is satisfactory, do not pass dbt_cli_profile	2022-09-28 15:15:08.898528+00
ea283451-11e8-4b2f-a88c-5dc5a7ebc0d2	2022-09-28 15:22:38.585956+00	2022-09-28 15:22:38.585972+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	trigger airbyte sync	2022-09-28 15:22:36.567247+00
568e7d1f-a93f-4b3e-b395-c47901909d2b	2022-09-28 15:22:38.585983+00	2022-09-28 15:22:38.585987+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:22:36.602364+00
4c93c9d7-c8ba-4f9e-9d0a-106d3a781394	2022-09-28 15:22:38.585995+00	2022-09-28 15:22:38.586+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:22:36.602665+00
ebd7f18f-e368-4e56-9cea-605caa6f7b52	2022-09-28 15:23:16.866582+00	2022-09-28 15:23:16.866615+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	airbyte sync executed	2022-09-28 15:23:16.723422+00
7b6887ff-e6cf-4744-b61b-49e194cb695c	2022-09-28 15:23:16.866634+00	2022-09-28 15:23:16.866641+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	get postgres profile	2022-09-28 15:23:16.723871+00
d3ef5ea6-c5c3-45c5-bbae-494d4967f0a5	2022-09-28 15:23:16.866652+00	2022-09-28 15:23:16.866659+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	dbt deps	2022-09-28 15:23:16.724487+00
dfe8f70a-e050-4781-8068-e0b267f1bda2	2022-09-28 15:23:16.86667+00	2022-09-28 15:23:16.866675+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:23:16.755955+00
47c136b1-f6a0-4319-963b-5399499237d2	2022-09-28 15:23:16.866686+00	2022-09-28 15:23:16.866692+00	prefect.flow_runs	20	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:23:16.756513+00
eb764be8-be66-4afc-a8d7-57559fa3e1b3	2022-09-28 15:23:16.866706+00	2022-09-28 15:23:16.866712+00	prefect.task_runs	40	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	1316dc14-1d36-4db2-a5ae-04963797d3b2	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 137, in trigger_dbt_cli_command\n    profiles_dir.mkdir(exist_ok=True)\n  File "/usr/local/lib/python3.10/pathlib.py", line 1175, in mkdir\n    self._accessor.mkdir(self, mode)\nFileExistsError: [Errno 17] File exists: '/dev/null'	2022-09-28 15:23:16.784576+00
7a203ff3-502b-4f00-a52d-27b1bde60f20	2022-09-28 15:23:16.866723+00	2022-09-28 15:23:16.866729+00	prefect.flow_runs	40	331d82d7-76e4-46a9-9d5a-59f1b11b07b1	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 61, in main\n    trigger_dbt_cli_command("dbt deps", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, profiles_dir=profiles_dir)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 137, in trigger_dbt_cli_command\n    profiles_dir.mkdir(exist_ok=True)\n  File "/usr/local/lib/python3.10/pathlib.py", line 1175, in mkdir\n    self._accessor.mkdir(self, mode)\nFileExistsError: [Errno 17] File exists: '/dev/null'	2022-09-28 15:23:16.818445+00
96bb9994-a265-4299-b7ae-a909e6482424	2022-09-28 15:26:09.377739+00	2022-09-28 15:26:09.377756+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	trigger airbyte sync	2022-09-28 15:26:07.35942+00
2e94d902-60a8-41db-9fa7-ca350a81094b	2022-09-28 15:26:09.377768+00	2022-09-28 15:26:09.377772+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:26:07.386172+00
4a46c5ce-7c57-4778-ae9d-c86b6e1296b4	2022-09-28 15:26:09.377782+00	2022-09-28 15:26:09.377786+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:26:07.386597+00
bb8c9469-28c9-4fe1-b458-2d830bd5924d	2022-09-28 15:26:45.424274+00	2022-09-28 15:26:45.424301+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	airbyte sync executed	2022-09-28 15:26:44.443673+00
5547d78f-ec7e-454a-b891-641a5b4d1acf	2022-09-28 15:26:45.424318+00	2022-09-28 15:26:45.424327+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	get postgres profile	2022-09-28 15:26:44.444146+00
caf8c33b-80e2-4ef8-9716-faaef0550170	2022-09-28 15:26:45.424339+00	2022-09-28 15:26:45.424345+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	dbt deps	2022-09-28 15:26:44.445087+00
b8a89a5c-ae35-4359-b186-3082f13c230a	2022-09-28 15:26:45.424357+00	2022-09-28 15:26:45.424363+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:26:44.479177+00
bb0f4244-bfdd-4401-870a-c602492110f6	2022-09-28 15:26:45.424374+00	2022-09-28 15:26:45.424381+00	prefect.flow_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:26:44.479649+00
5bed6114-1bb8-4766-af1b-57e73524e601	2022-09-28 15:26:45.424392+00	2022-09-28 15:26:45.424397+00	prefect.task_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	8de7a2e2-18d8-45ae-b587-eaa616150fa6	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:26:44.506562+00
f5fb2327-c0a4-499a-ad80-ca112db49c6e	2022-09-28 15:26:45.424408+00	2022-09-28 15:26:45.424414+00	prefect.task_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	8de7a2e2-18d8-45ae-b587-eaa616150fa6	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir dbt_sample	2022-09-28 15:26:44.507145+00
1f8e5f99-ea3e-4d26-b863-efb6529a68c6	2022-09-28 15:29:35.03895+00	2022-09-28 15:29:35.038977+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	trigger airbyte sync	2022-09-28 15:29:33.025892+00
e4b0548d-1b66-45ef-ab4d-d1ff248abd76	2022-09-28 15:29:35.038989+00	2022-09-28 15:29:35.038994+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:29:33.056383+00
c6483e99-42b1-4a1c-bde7-5a8d17e00f94	2022-09-28 15:29:35.039002+00	2022-09-28 15:29:35.039006+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:29:33.057497+00
44bef117-868f-49ff-b1e1-10c01b6557fb	2022-09-28 15:30:05.081254+00	2022-09-28 15:30:05.081266+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	airbyte sync executed	2022-09-28 15:30:03.580651+00
33f465c3-04d9-4187-9f67-9624f30b45ce	2022-09-28 15:30:05.081276+00	2022-09-28 15:30:05.08128+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	get postgres profile	2022-09-28 15:30:03.580952+00
bb8c424c-f0c1-4b3c-95ac-27c262d2182c	2022-09-28 15:30:05.081287+00	2022-09-28 15:30:05.081291+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	dbt deps	2022-09-28 15:30:03.58147+00
3aba4759-0ff1-4f2d-a42d-28d182ed116d	2022-09-28 15:30:05.081298+00	2022-09-28 15:30:05.081301+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:30:03.599021+00
c94e6179-052e-4faf-bb0a-0b59f8e834a3	2022-09-28 15:30:05.081308+00	2022-09-28 15:30:05.081312+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:30:03.599326+00
581f956e-03c6-4533-9d83-896969cd2c63	2022-09-28 15:30:05.081319+00	2022-09-28 15:30:05.081323+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:30:03.616754+00
81cc5908-1787-42b7-8aad-f8cce5690369	2022-09-28 15:30:05.08133+00	2022-09-28 15:30:05.081333+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:30:03.617109+00
b4a14397-2f8f-4e5b-a690-60f5a974c80c	2022-09-28 15:30:09.114131+00	2022-09-28 15:30:09.114142+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	[0m15:30:07    Installed from version 0.8.2\n	2022-09-28 15:30:07.246488+00
b1c19e88-53b4-4f52-b017-38f0c24d6296	2022-09-28 15:30:09.11415+00	2022-09-28 15:30:09.114154+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	[0m15:30:07    Updated version available: 0.9.2\n[0m15:30:07  \n[0m15:30:07  Updates available for packages: ['dbt-labs/dbt_utils']                 \nUpdate your versions in packages.yml, then run dbt deps\n	2022-09-28 15:30:07.246976+00
fe866096-8b0c-461f-a251-0e7834a7bf0d	2022-09-28 15:26:48.391821+00	2022-09-28 15:26:48.391838+00	prefect.task_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	8de7a2e2-18d8-45ae-b587-eaa616150fa6	[0m15:26:48  Encountered an error:\nRuntime Error\n  fatal: Invalid --project-dir flag. Not a dbt project. Missing dbt_project.yml file\n	2022-09-28 15:26:48.063636+00
b9343977-2388-4862-a3cc-4368ae30ed3a	2022-09-28 15:26:48.391849+00	2022-09-28 15:26:48.391853+00	prefect.task_runs	20	711d4d60-0b62-4ad5-8b1f-be495c297ba6	8de7a2e2-18d8-45ae-b587-eaa616150fa6	[0m15:26:48  Traceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 129, in main\n    results, succeeded = handle_and_check(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 191, in handle_and_check\n    task, res = run_from_args(parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 218, in run_from_args\n    task = parsed.cls.from_args(args=parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/deps.py", line 90, in from_args\n    move_to_nearest_project_dir(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 171, in move_to_nearest_project_dir\n    nearest_project_dir = get_nearest_project_dir(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 150, in get_nearest_project_dir\n    raise dbt.exceptions.RuntimeException(\ndbt.exceptions.RuntimeException: Runtime Error\n  fatal: Invalid --project-dir flag. Not a dbt project. Missing dbt_project.yml file\n\n	2022-09-28 15:26:48.066356+00
1be965a4-b66a-4ca9-a3c4-ebf058bcc54f	2022-09-28 15:26:48.391861+00	2022-09-28 15:26:48.391865+00	prefect.task_runs	40	711d4d60-0b62-4ad5-8b1f-be495c297ba6	8de7a2e2-18d8-45ae-b587-eaa616150fa6	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  fatal: Invalid --project-dir flag. Not a dbt project. Missing dbt_project.yml file\n	2022-09-28 15:26:48.323349+00
3624857a-5c99-4633-8ad5-c3085580622a	2022-09-28 15:26:48.391873+00	2022-09-28 15:26:48.391877+00	prefect.flow_runs	40	711d4d60-0b62-4ad5-8b1f-be495c297ba6	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 60, in main\n    trigger_dbt_cli_command("dbt deps", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  fatal: Invalid --project-dir flag. Not a dbt project. Missing dbt_project.yml file\n	2022-09-28 15:26:48.348891+00
a9c461d9-bcfb-4633-9c67-bd10080f181d	2022-09-28 15:30:07.09926+00	2022-09-28 15:30:07.099273+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	[0m15:30:05  Running with dbt=1.2.1\n	2022-09-28 15:30:05.851169+00
3eab867c-e78f-496f-ac3a-7c63e670f1ad	2022-09-28 15:30:07.099283+00	2022-09-28 15:30:07.099286+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	06cea5eb-9d2c-4f41-9bb2-4054bd01616e	[0m15:30:06  Installing dbt-labs/dbt_utils\n	2022-09-28 15:30:06.57043+00
6b2ca3de-63fa-4a3e-86ce-c85da09ca9ec	2022-09-28 15:30:11.132341+00	2022-09-28 15:30:11.132352+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	dbt run	2022-09-28 15:30:09.461145+00
dc740260-6423-488f-800c-7d5e7b6cbfc7	2022-09-28 15:30:11.132361+00	2022-09-28 15:30:11.132364+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Created task run 'trigger_dbt_cli_command-321ca940-1' for task 'trigger_dbt_cli_command'	2022-09-28 15:30:09.479182+00
9dcfb253-90d2-43a1-8f17-625193840cbb	2022-09-28 15:30:11.132371+00	2022-09-28 15:30:11.132374+00	prefect.flow_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Executing 'trigger_dbt_cli_command-321ca940-1' immediately...	2022-09-28 15:30:09.479502+00
dc517d57-1463-4d3f-a1b4-08b311341499	2022-09-28 15:30:11.132381+00	2022-09-28 15:30:11.132384+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:30:09.501268+00
e15f184e-b68c-4f9e-ada3-567b33e774ec	2022-09-28 15:30:11.13239+00	2022-09-28 15:30:11.132393+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	Running dbt command: dbt run --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:30:09.501604+00
83cee615-058d-46fc-82b1-de87193072e5	2022-09-28 15:30:11.626571+00	2022-09-28 15:30:11.626583+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	[0m15:30:11  Encountered an error while reading the project:\n[0m15:30:11    ERROR: Runtime Error\n  Could not find profile named 'dbt_sample'\n	2022-09-28 15:30:11.428308+00
9f3e9f87-ec0e-464c-bce5-57cc7bc03079	2022-09-28 15:30:11.626593+00	2022-09-28 15:30:11.626597+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	[0m15:30:11  Encountered an error:\nRuntime Error\n  Could not run dbt\n	2022-09-28 15:30:11.430013+00
f722c6fe-16ad-4a2e-a0f3-d245134f0529	2022-09-28 15:30:11.626604+00	2022-09-28 15:30:11.626608+00	prefect.task_runs	20	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	[0m15:30:11  Traceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 108, in from_args\n    config = cls.ConfigType.from_args(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/config/runtime.py", line 226, in from_args\n    project, profile = cls.collect_parts(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/config/runtime.py", line 202, in collect_parts\n    profile = cls._get_rendered_profile(args, profile_renderer, profile_name)\n  File "/usr/local/lib/python3.10/site-packages/dbt/config/runtime.py", line 187, in _get_rendered_profile\n    return Profile.render_from_args(args, profile_renderer, profile_name)\n  File "/usr/local/lib/python3.10/site-packages/dbt/config/profile.py", line 428, in render_from_args\n    return cls.from_raw_profiles(\n  File "/usr/local/lib/python3.10/site-packages/dbt/config/profile.py", line 384, in from_raw_profiles\n    raise DbtProjectError("Could not find profile named '{}'".format(profile_name))\ndbt.exceptions.DbtProjectError: Runtime Error\n  Could not find profile named 'dbt_sample'\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 129, in main\n    results, succeeded = handle_and_check(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 191, in handle_and_check\n    task, res = run_from_args(parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/main.py", line 218, in run_from_args\n    task = parsed.cls.from_args(args=parsed)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 185, in from_args\n    return super().from_args(args)\n  File "/usr/local/lib/python3.10/site-packages/dbt/task/base.py", line 114, in from_args\n    raise dbt.exceptions.RuntimeException("Could not run dbt") from exc\ndbt.exceptions.RuntimeException: Runtime Error\n  Could not run dbt\n\n	2022-09-28 15:30:11.434072+00
df06ae77-e8c9-426d-ac5a-52c31786eb6b	2022-09-28 15:30:11.626615+00	2022-09-28 15:30:11.626618+00	prefect.task_runs	40	2c43fe04-d94e-40dd-a955-dac75a7d1f72	f92a433e-2a65-4191-ac8c-d79b8ea8cab1	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  Could not run dbt\n	2022-09-28 15:30:11.582866+00
9e776cbc-c1f6-48db-be79-c31bf2e8e921	2022-09-28 15:30:11.626625+00	2022-09-28 15:30:11.626629+00	prefect.flow_runs	40	2c43fe04-d94e-40dd-a955-dac75a7d1f72	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 62, in main\n    trigger_dbt_cli_command("dbt run", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 2:\n  Could not run dbt\n	2022-09-28 15:30:11.600851+00
3df7bcd2-3de0-4b84-9282-a6396d0a9405	2022-09-28 15:38:31.35327+00	2022-09-28 15:38:31.353295+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	trigger airbyte sync	2022-09-28 15:38:29.336858+00
2a76f1ef-ff41-4822-a386-7b00cd828085	2022-09-28 15:38:31.353311+00	2022-09-28 15:38:31.353317+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:38:29.375504+00
52654874-e185-4f62-99e0-2395c5c85624	2022-09-28 15:38:45.378007+00	2022-09-28 15:38:45.378018+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	airbyte sync executed	2022-09-28 15:38:45.184289+00
a5931ed6-6e0f-4fae-9c93-a3fdb0429787	2022-09-28 15:38:45.378028+00	2022-09-28 15:38:45.378032+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	get postgres profile	2022-09-28 15:38:45.184682+00
0c8c48a0-3908-4a86-a23a-e7187593fee6	2022-09-28 15:38:45.37804+00	2022-09-28 15:38:45.378043+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	dbt deps	2022-09-28 15:38:45.185314+00
35266161-ea6b-4c72-9750-42aeabab4728	2022-09-28 15:38:45.37805+00	2022-09-28 15:38:45.378054+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:38:45.214047+00
46ce99e3-ec1b-4651-982a-c2e303780b1a	2022-09-28 15:38:45.378061+00	2022-09-28 15:38:45.378064+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:38:45.21471+00
116b550d-6a38-4fb3-abae-9c1fcc092322	2022-09-28 15:38:45.378072+00	2022-09-28 15:38:45.378075+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:38:45.238352+00
80c28eec-7cde-4a61-ad18-ef6b898abae4	2022-09-28 15:38:45.378082+00	2022-09-28 15:38:45.378086+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:38:45.238681+00
bb9cdc42-33fa-40d8-8baa-61a20cd98c47	2022-09-28 15:38:49.396316+00	2022-09-28 15:38:49.396329+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	[0m15:38:47  Running with dbt=1.2.1\n	2022-09-28 15:38:47.696149+00
230878b3-9df6-4cdb-831d-48eeccbf6c63	2022-09-28 15:38:49.396338+00	2022-09-28 15:38:49.396343+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	[0m15:38:48  Installing dbt-labs/dbt_utils\n	2022-09-28 15:38:48.266412+00
3bfdc893-48f7-475f-8092-1d294b651e6d	2022-09-28 15:38:49.39635+00	2022-09-28 15:38:49.396354+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	[0m15:38:48    Installed from version 0.8.2\n[0m15:38:48    Updated version available: 0.9.2\n	2022-09-28 15:38:48.895322+00
143127d9-d9da-4c13-85af-5385ab47d61f	2022-09-28 15:38:49.396361+00	2022-09-28 15:38:49.396365+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	e3336023-a168-4dcd-addb-45bfd0f25c4c	[0m15:38:48  \n[0m15:38:48  Updates available for packages: ['dbt-labs/dbt_utils']                 \nUpdate your versions in packages.yml, then run dbt deps\n	2022-09-28 15:38:48.895881+00
8de25365-5959-4453-890a-c2112996557b	2022-09-28 15:38:51.414215+00	2022-09-28 15:38:51.414226+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	dbt run	2022-09-28 15:38:51.093171+00
769c0b57-a0c5-443e-a91a-b7133e375d89	2022-09-28 15:38:51.414236+00	2022-09-28 15:38:51.414241+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Created task run 'trigger_dbt_cli_command-321ca940-1' for task 'trigger_dbt_cli_command'	2022-09-28 15:38:51.108955+00
7758af05-deec-4d45-8958-643c7a4f6cf4	2022-09-28 15:38:51.414248+00	2022-09-28 15:38:51.414252+00	prefect.flow_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Executing 'trigger_dbt_cli_command-321ca940-1' immediately...	2022-09-28 15:38:51.10926+00
520d0fbb-de4a-4c77-9cbf-d7728f1e2916	2022-09-28 15:38:51.414259+00	2022-09-28 15:38:51.414263+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:38:51.124755+00
989d9197-a81f-4f0d-b14c-3bec7f797742	2022-09-28 15:38:51.41427+00	2022-09-28 15:38:51.414273+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	Running dbt command: dbt run --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:38:51.125056+00
34c9c4a4-4e4b-402d-8dd0-d147f909b355	2022-09-28 15:38:53.430236+00	2022-09-28 15:38:53.430248+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	[0m15:38:53  Running with dbt=1.2.1\n	2022-09-28 15:38:53.162563+00
cdf646bb-af49-4e8e-b560-b2a296ba0998	2022-09-28 15:38:53.430258+00	2022-09-28 15:38:53.430262+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	[0m15:38:53  Unable to do partial parsing because profile has changed\n[0m15:38:53  Unable to do partial parsing because env vars used in profiles.yml have changed\n	2022-09-28 15:38:53.186572+00
c2b81076-0893-4cc3-a5c2-ffe79eb447d7	2022-09-28 15:38:55.445605+00	2022-09-28 15:38:55.445616+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	[0m15:38:53  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:38:53.982753+00
51ad70c3-d996-41ba-820c-d052c6ca384c	2022-09-28 15:38:55.445625+00	2022-09-28 15:38:55.445628+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	[0m15:38:53  \n	2022-09-28 15:38:53.984016+00
ddd4e6f5-aef2-48a2-bd80-ee1f74a3b432	2022-09-28 15:38:55.445635+00	2022-09-28 15:38:55.445638+00	prefect.task_runs	20	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	[0m15:38:54  Encountered an error:\nDatabase Error\n  connection to server at "localhost" (127.0.0.1), port 5432 failed: Connection refused\n  \tIs the server running on that host and accepting TCP/IP connections?\n  connection to server at "localhost" (::1), port 5432 failed: Cannot assign requested address\n  \tIs the server running on that host and accepting TCP/IP connections?\n  \n	2022-09-28 15:38:54.997276+00
7da3832c-17ae-400f-904c-dd7c64484dc1	2022-09-28 15:38:57.600317+00	2022-09-28 15:38:57.60033+00	prefect.task_runs	40	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	5faa467e-48f1-4bbb-bce8-62ca81c8f67e	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 1:\n  \tIs the server running on that host and accepting TCP/IP connections?\n	2022-09-28 15:38:57.554123+00
a92c70ad-3b02-4d86-bbec-56b6efc2e852	2022-09-28 15:38:57.600339+00	2022-09-28 15:38:57.600344+00	prefect.flow_runs	40	80b9ccbc-eeb1-41f3-98ae-3a2baaab7952	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 62, in main\n    trigger_dbt_cli_command("dbt run", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 1:\n  \tIs the server running on that host and accepting TCP/IP connections?\n	2022-09-28 15:38:57.571747+00
fdc81476-9a4b-49dc-9a0c-049c7ab0aa5f	2022-09-28 15:40:16.817488+00	2022-09-28 15:40:16.817504+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	trigger airbyte sync	2022-09-28 15:40:14.803606+00
b011a025-def6-4806-9a56-c3f679cef60a	2022-09-28 15:40:16.817514+00	2022-09-28 15:40:16.817518+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:40:14.832799+00
5f14094f-a25e-4e81-a920-76411f1c96cd	2022-09-28 15:40:16.817526+00	2022-09-28 15:40:16.817529+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:40:14.833127+00
467795af-dbc9-4165-b987-ed128527c8d3	2022-09-28 15:40:54.858626+00	2022-09-28 15:40:54.858647+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	airbyte sync executed	2022-09-28 15:40:54.842046+00
e928b54a-c0e8-4c7e-919c-384f82ef54d9	2022-09-28 15:40:54.858658+00	2022-09-28 15:40:54.858662+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	get postgres profile	2022-09-28 15:40:54.842528+00
657c417a-f970-468f-9bb1-adb6ebc6d6a7	2022-09-28 15:40:54.85867+00	2022-09-28 15:40:54.858674+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	dbt deps	2022-09-28 15:40:54.843147+00
fe30d66c-7bde-4355-92e2-734dd456c4cb	2022-09-28 15:40:56.886828+00	2022-09-28 15:40:56.886851+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:40:54.877685+00
9f263627-cef8-4823-a767-53c461204a25	2022-09-28 15:40:56.886866+00	2022-09-28 15:40:56.886872+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:40:54.878159+00
da8dbbbb-f688-4ab0-aa81-a6cbef1b77d7	2022-09-28 15:40:56.886884+00	2022-09-28 15:40:56.88689+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:40:54.906846+00
ef0c7ec1-6919-4156-8da1-c61b677f0daf	2022-09-28 15:40:56.886901+00	2022-09-28 15:40:56.886907+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:40:54.907755+00
8ae435e1-9176-4bd3-885f-08737f026e03	2022-09-28 15:40:58.908365+00	2022-09-28 15:40:58.908387+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	[0m15:40:58  Running with dbt=1.2.1\n	2022-09-28 15:40:58.003405+00
3a52b3f9-97de-4a7c-99ad-c296725c686d	2022-09-28 15:40:58.908398+00	2022-09-28 15:40:58.908403+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	[0m15:40:58  Installing dbt-labs/dbt_utils\n	2022-09-28 15:40:58.648268+00
44bd2874-56a3-4e7b-afd0-3269508d4fa4	2022-09-28 15:41:00.936139+00	2022-09-28 15:41:00.936168+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	[0m15:40:59    Installed from version 0.8.2\n[0m15:40:59    Updated version available: 0.9.2\n	2022-09-28 15:40:59.287464+00
d0b99864-5afd-4e4a-9193-7cc4142bbb56	2022-09-28 15:41:00.936184+00	2022-09-28 15:41:00.93619+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	827443da-b143-40fe-9931-090379c0ca49	[0m15:40:59  \n[0m15:40:59  Updates available for packages: ['dbt-labs/dbt_utils']                 \nUpdate your versions in packages.yml, then run dbt deps\n	2022-09-28 15:40:59.288316+00
4949404f-8bf9-4424-ad19-62a1d64e2096	2022-09-28 15:41:02.960265+00	2022-09-28 15:41:02.96029+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	dbt run	2022-09-28 15:41:01.552956+00
4f574969-f57e-4025-bcd4-bb556e5d2faa	2022-09-28 15:41:02.960308+00	2022-09-28 15:41:02.960314+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Created task run 'trigger_dbt_cli_command-321ca940-1' for task 'trigger_dbt_cli_command'	2022-09-28 15:41:01.580731+00
903c5a79-959d-4d1f-908c-2e922fc50506	2022-09-28 15:41:02.960326+00	2022-09-28 15:41:02.960333+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Executing 'trigger_dbt_cli_command-321ca940-1' immediately...	2022-09-28 15:41:01.581285+00
435275c4-3a07-47f1-85e2-fa49abb8e173	2022-09-28 15:41:02.960344+00	2022-09-28 15:41:02.96035+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:41:01.611029+00
1dea8911-546e-43b2-b160-b5108133b037	2022-09-28 15:41:02.960362+00	2022-09-28 15:41:02.960368+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	Running dbt command: dbt run --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:41:01.611429+00
6d9492eb-e637-4912-8de5-ccdfb43155ec	2022-09-28 15:41:04.991944+00	2022-09-28 15:41:04.991965+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:04  Running with dbt=1.2.1\n	2022-09-28 15:41:04.76947+00
120e7db2-4774-4f24-a46b-762708f2e98a	2022-09-28 15:41:04.99198+00	2022-09-28 15:41:04.991985+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:04  Unable to do partial parsing because profile has changed\n	2022-09-28 15:41:04.806365+00
70119076-effb-41f8-9c29-331328a593c8	2022-09-28 15:41:07.01607+00	2022-09-28 15:41:07.016095+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:41:06.022442+00
03c8db5d-1863-4bc8-8604-bfa491c7001c	2022-09-28 15:41:07.016112+00	2022-09-28 15:41:07.016119+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  \n	2022-09-28 15:41:06.024237+00
9203354c-67d2-44a7-b7bd-547b7466f4b7	2022-09-28 15:41:07.016129+00	2022-09-28 15:41:07.016134+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  Concurrency: 4 threads (target='default')\n	2022-09-28 15:41:06.162992+00
fa0fc92d-259f-40db-85ac-47f389b91646	2022-09-28 15:41:07.01616+00	2022-09-28 15:41:07.016166+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  \n	2022-09-28 15:41:06.163593+00
de591cb7-b09b-42ac-a462-775ccca5a5da	2022-09-28 15:41:07.016176+00	2022-09-28 15:41:07.016181+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  1 of 1 START table model sample.global_content_views ........................... [RUN]\n	2022-09-28 15:41:06.184026+00
6021b783-6eb6-4487-b8b7-ae216d9c6efa	2022-09-28 15:41:07.016192+00	2022-09-28 15:41:07.016197+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  1 of 1 OK created table model sample.global_content_views ...................... [[32mSELECT 3[0m in 0.17s]\n	2022-09-28 15:41:06.351428+00
1696488d-18f9-4b0e-a1b4-00235a26bb41	2022-09-28 15:41:07.016207+00	2022-09-28 15:41:07.016211+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  \n	2022-09-28 15:41:06.379119+00
ee49b36a-dfd0-443d-965f-8faa7e2043bf	2022-09-28 15:41:07.016222+00	2022-09-28 15:41:07.016227+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  Finished running 1 table model in 0 hours 0 minutes and 0.35 seconds (0.35s).\n	2022-09-28 15:41:06.37974+00
234ac923-66cd-4b22-b9be-584c07efc8a7	2022-09-28 15:41:07.016238+00	2022-09-28 15:41:07.016244+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  \n	2022-09-28 15:41:06.390672+00
5675c19e-588c-473d-a850-7ffa41e88433	2022-09-28 15:41:07.016255+00	2022-09-28 15:41:07.016261+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	302ec114-0da8-49af-b849-6f0887743afd	[0m15:41:06  [32mCompleted successfully[0m\n[0m15:41:06  \n[0m15:41:06  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1\n	2022-09-28 15:41:06.391503+00
501b3c6e-95c8-4cec-9617-d411ff05f68e	2022-09-28 15:41:09.043216+00	2022-09-28 15:41:09.043236+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	dbt test	2022-09-28 15:41:08.894669+00
b27ebbb7-0aa2-4c19-a247-b9c46c735a3d	2022-09-28 15:41:09.043248+00	2022-09-28 15:41:09.043254+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Created task run 'trigger_dbt_cli_command-321ca940-2' for task 'trigger_dbt_cli_command'	2022-09-28 15:41:08.921956+00
a727831d-523f-450a-9018-820881628d6e	2022-09-28 15:41:09.043265+00	2022-09-28 15:41:09.04327+00	prefect.flow_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Executing 'trigger_dbt_cli_command-321ca940-2' immediately...	2022-09-28 15:41:08.922455+00
07c06750-e5fa-4016-87db-9968575e46f2	2022-09-28 15:41:09.043279+00	2022-09-28 15:41:09.043284+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:41:08.94835+00
80b87e7f-6533-4de3-869e-10f5569d70c5	2022-09-28 15:41:09.043293+00	2022-09-28 15:41:09.043298+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	Running dbt command: dbt test --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:41:08.948784+00
d0cac3dc-2faf-4e8d-b8e5-d47ae39a5a9c	2022-09-28 15:41:14.950634+00	2022-09-28 15:41:14.950649+00	prefect.task_runs	40	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 1:\n[0m15:41:12  Done. PASS=0 WARN=0 ERROR=2 SKIP=0 TOTAL=2\n	2022-09-28 15:41:14.884554+00
01224d9d-996c-4947-adb9-dd288db7ba0c	2022-09-28 15:41:14.95066+00	2022-09-28 15:41:14.950665+00	prefect.flow_runs	40	682f80bc-d629-437b-b934-89bf8eb37be0	\N	Encountered exception during execution:\nTraceback (most recent call last):\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 595, in orchestrate_flow_run\n    result = await run_sync(flow_call)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 57, in run_sync_in_worker_thread\n    return await anyio.to_thread.run_sync(call, cancellable=True)\n  File "/usr/local/lib/python3.10/site-packages/anyio/to_thread.py", line 31, in run_sync\n    return await get_asynclib().run_sync_in_worker_thread(\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 937, in run_sync_in_worker_thread\n    return await future\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 867, in run\n    result = context.run(func, *args)\n  File "/root/flows/example.py", line 64, in main\n    trigger_dbt_cli_command("dbt test", dbt_cli_profile=dbt_cli_profile, project_dir=project_dir, overwrite_profiles=True)\n  File "/usr/local/lib/python3.10/site-packages/prefect/tasks.py", line 295, in __call__\n    return enter_task_run_engine(\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 735, in enter_task_run_engine\n    return run_async_from_worker_thread(begin_run)\n  File "/usr/local/lib/python3.10/site-packages/prefect/utilities/asyncutils.py", line 137, in run_async_from_worker_thread\n    return anyio.from_thread.run(call)\n  File "/usr/local/lib/python3.10/site-packages/anyio/from_thread.py", line 49, in run\n    return asynclib.run_async_from_thread(func, *args)\n  File "/usr/local/lib/python3.10/site-packages/anyio/_backends/_asyncio.py", line 970, in run_async_from_thread\n    return f.result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 458, in result\n    return self.__get_result()\n  File "/usr/local/lib/python3.10/concurrent/futures/_base.py", line 403, in __get_result\n    raise self._exception\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 863, in get_task_call_return_value\n    return await future._result()\n  File "/usr/local/lib/python3.10/site-packages/prefect/futures.py", line 236, in _result\n    return final_state.result(raise_on_failure=raise_on_failure)\n  File "/usr/local/lib/python3.10/site-packages/prefect/orion/schemas/states.py", line 143, in result\n    raise data\n  File "/usr/local/lib/python3.10/site-packages/prefect/engine.py", line 1185, in orchestrate_task_run\n    result = await task.fn(*args, **kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_dbt/cli/commands.py", line 158, in trigger_dbt_cli_command\n    result = await shell_run_command.fn(command=command, **shell_run_command_kwargs)\n  File "/usr/local/lib/python3.10/site-packages/prefect_shell/commands.py", line 90, in shell_run_command\n    raise RuntimeError(msg)\nRuntimeError: Command failed with exit code 1:\n[0m15:41:12  Done. PASS=0 WARN=0 ERROR=2 SKIP=0 TOTAL=2\n	2022-09-28 15:41:14.909509+00
24246388-7eb6-4d49-9295-7fcef26cd800	2022-09-28 15:41:13.072425+00	2022-09-28 15:41:13.07246+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  Running with dbt=1.2.1\n	2022-09-28 15:41:12.006221+00
a072a5ac-55bc-41b1-b516-224f8dc1ce25	2022-09-28 15:41:13.072475+00	2022-09-28 15:41:13.072481+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:41:12.084122+00
68e91773-40fb-481b-96fe-7c6f1dd81bde	2022-09-28 15:41:13.072494+00	2022-09-28 15:41:13.0725+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.086145+00
bd9f2f54-1c79-4685-9828-14f24a9dedfe	2022-09-28 15:41:13.07251+00	2022-09-28 15:41:13.072516+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  Concurrency: 4 threads (target='default')\n	2022-09-28 15:41:12.184611+00
055850b1-82f3-4dea-9371-c4814da4ab19	2022-09-28 15:41:13.072527+00	2022-09-28 15:41:13.072532+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.185694+00
7544e891-c6f4-47a6-a9f3-cbb15e4652db	2022-09-28 15:41:13.072543+00	2022-09-28 15:41:13.072548+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  1 of 2 START test not_null_global_content_views_content_id ..................... [RUN]\n	2022-09-28 15:41:12.191133+00
6d6304c4-89d0-4322-9e77-e8b528660711	2022-09-28 15:41:13.072559+00	2022-09-28 15:41:13.072565+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  2 of 2 START test unique_global_content_views_content_id ....................... [RUN]\n	2022-09-28 15:41:12.191785+00
b6fc055c-eabe-494e-b74f-ea0214c4e5a0	2022-09-28 15:41:13.072575+00	2022-09-28 15:41:13.07258+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  2 of 2 ERROR unique_global_content_views_content_id ............................ [[31mERROR[0m in 0.08s]\n	2022-09-28 15:41:12.27434+00
29adf89d-5468-4e26-9fea-0b8a43726627	2022-09-28 15:41:13.072592+00	2022-09-28 15:41:13.072597+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  1 of 2 ERROR not_null_global_content_views_content_id .......................... [[31mERROR[0m in 0.08s]\n	2022-09-28 15:41:12.275591+00
ec15a823-4393-409b-84c1-27ee891fcfc6	2022-09-28 15:41:13.072608+00	2022-09-28 15:41:13.072614+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.298792+00
4214f348-49dd-449d-b568-2f0c9f830ab9	2022-09-28 15:41:13.072625+00	2022-09-28 15:41:13.07263+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  Finished running 2 tests in 0 hours 0 minutes and 0.21 seconds (0.21s).\n	2022-09-28 15:41:12.299814+00
96205251-a61d-4802-85b1-b36096397058	2022-09-28 15:41:13.072641+00	2022-09-28 15:41:13.072647+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.310123+00
fb3bdfdf-2430-49ec-96b2-7808d813f19b	2022-09-28 15:41:13.072657+00	2022-09-28 15:41:13.072663+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  [31mCompleted with 2 errors and 0 warnings:[0m\n[0m15:41:12  \n[0m15:41:12  [33mDatabase Error in test unique_global_content_views_content_id (models/content/schema.yml)[0m\n	2022-09-28 15:41:12.310844+00
aa02443e-1caa-4cca-8d48-1784074d19bc	2022-09-28 15:41:13.072674+00	2022-09-28 15:41:13.07268+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12    column "content_id" does not exist\n[0m15:41:12    LINE 12:     content_id as unique_field,\n	2022-09-28 15:41:12.311209+00
ef9ed277-599e-4468-ac18-96ed92e9ae6f	2022-09-28 15:41:13.072691+00	2022-09-28 15:41:13.072696+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12                 ^\n	2022-09-28 15:41:12.311639+00
af568b96-ebbd-42c0-88e9-dfcc97555c3e	2022-09-28 15:41:13.072707+00	2022-09-28 15:41:13.072713+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12    compiled SQL at target/run/dbt_sample/models/content/schema.yml/unique_global_content_views_content_id.sql\n	2022-09-28 15:41:12.311889+00
1a79c02f-b68b-493c-947e-5ae3e47d8daa	2022-09-28 15:41:13.072723+00	2022-09-28 15:41:13.072729+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.312252+00
aea8dec2-4e10-4181-ae69-dfaca96926af	2022-09-28 15:41:13.07274+00	2022-09-28 15:41:13.072746+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  [33mDatabase Error in test not_null_global_content_views_content_id (models/content/schema.yml)[0m\n	2022-09-28 15:41:12.312519+00
a17abf20-9a44-4194-b03e-2ba7ea97a524	2022-09-28 15:41:13.072756+00	2022-09-28 15:41:13.072762+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12    column "content_id" does not exist\n	2022-09-28 15:41:12.31277+00
527e1f27-70e4-457a-8414-3b026ce0eecb	2022-09-28 15:41:13.072772+00	2022-09-28 15:41:13.072778+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12    LINE 13: select content_id\n	2022-09-28 15:41:12.313138+00
20e147bf-35bc-4839-900d-4b0e611a9103	2022-09-28 15:41:13.072789+00	2022-09-28 15:41:13.072795+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12                    ^\n	2022-09-28 15:41:12.313749+00
27486738-aa49-4978-af2f-721a2f79cf9c	2022-09-28 15:41:13.072806+00	2022-09-28 15:41:13.072812+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12    compiled SQL at target/run/dbt_sample/models/content/schema.yml/not_null_global_content_views_content_id.sql\n	2022-09-28 15:41:12.314048+00
3d8c37e9-822c-47bc-8f0e-c106f96700e0	2022-09-28 15:41:13.072823+00	2022-09-28 15:41:13.072829+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  \n	2022-09-28 15:41:12.314393+00
abcdc6af-30d8-4276-99da-cb53bfbda8d2	2022-09-28 15:41:13.07284+00	2022-09-28 15:41:13.072865+00	prefect.task_runs	20	682f80bc-d629-437b-b934-89bf8eb37be0	baa37b73-3d8f-473a-8710-b88014142d2b	[0m15:41:12  Done. PASS=0 WARN=0 ERROR=2 SKIP=0 TOTAL=2\n	2022-09-28 15:41:12.314825+00
8d124cc4-8b34-4e32-8abe-792fd50a721b	2022-09-28 15:44:37.619418+00	2022-09-28 15:44:37.619433+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	trigger airbyte sync	2022-09-28 15:44:35.606032+00
6236155a-6089-4050-a398-3d5c9b646563	2022-09-28 15:44:37.619444+00	2022-09-28 15:44:37.619449+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:44:35.636806+00
6ffbb5eb-51ed-4c2e-aaa4-26029271f7d7	2022-09-28 15:44:37.619457+00	2022-09-28 15:44:37.619461+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:44:35.637165+00
c8f30ed7-0c68-4adf-b6a9-85febf036e89	2022-09-28 15:45:09.677361+00	2022-09-28 15:45:09.677386+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	airbyte sync executed	2022-09-28 15:45:09.26037+00
e8162f71-45a3-48fa-ab50-7153f9f0fa18	2022-09-28 15:45:09.677402+00	2022-09-28 15:45:09.677409+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	get postgres profile	2022-09-28 15:45:09.260915+00
8790f189-e3ca-462e-8211-10fb4e246eb3	2022-09-28 15:45:09.677419+00	2022-09-28 15:45:09.677425+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	dbt deps	2022-09-28 15:45:09.262598+00
470a61c0-5f3e-4a94-abd7-4be7f9f5be46	2022-09-28 15:45:09.677435+00	2022-09-28 15:45:09.67744+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:45:09.288985+00
87ae1935-6e7e-4d44-957c-fdf13e5a8f0e	2022-09-28 15:45:09.677451+00	2022-09-28 15:45:09.677456+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:45:09.289498+00
49b7057c-e72f-47bc-acc7-8678ce23b189	2022-09-28 15:45:09.677467+00	2022-09-28 15:45:09.677472+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:45:09.32089+00
da15eb5e-fb31-42ea-b0aa-dc39c9a65e04	2022-09-28 15:45:09.677483+00	2022-09-28 15:45:09.677488+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:45:09.321416+00
07ff396e-b0b2-41fc-b204-8289d0442832	2022-09-28 15:45:13.708886+00	2022-09-28 15:45:13.708902+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	[0m15:45:12  Running with dbt=1.2.1\n	2022-09-28 15:45:12.308317+00
5cff11d0-dd46-42f0-8b6d-fe5aa2752841	2022-09-28 15:45:13.708912+00	2022-09-28 15:45:13.708915+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	[0m15:45:12  Installing dbt-labs/dbt_utils\n	2022-09-28 15:45:12.94366+00
5254f06f-85bd-41e8-ae01-10bec4f1a3b6	2022-09-28 15:45:15.732977+00	2022-09-28 15:45:15.732997+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	[0m15:45:13    Installed from version 0.8.2\n[0m15:45:13    Updated version available: 0.9.2\n	2022-09-28 15:45:13.752302+00
62a2e45a-ea69-460b-9c8e-0b430d337887	2022-09-28 15:45:15.733011+00	2022-09-28 15:45:15.733017+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	[0m15:45:13  \n	2022-09-28 15:45:13.753067+00
ee26614f-c282-42a0-8249-63ecb88146a2	2022-09-28 15:45:15.733026+00	2022-09-28 15:45:15.733031+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	025f15dc-90dd-4a5e-9ac4-c66d5d87568b	[0m15:45:13  Updates available for packages: ['dbt-labs/dbt_utils']                 \nUpdate your versions in packages.yml, then run dbt deps\n	2022-09-28 15:45:13.75345+00
4f883b47-1a49-4da2-8fc1-6fc83a9d463e	2022-09-28 15:45:17.758461+00	2022-09-28 15:45:17.758498+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	dbt run	2022-09-28 15:45:16.180689+00
09dc9d5f-964b-4226-aad9-a36094f978e2	2022-09-28 15:45:17.758526+00	2022-09-28 15:45:17.758532+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Created task run 'trigger_dbt_cli_command-321ca940-1' for task 'trigger_dbt_cli_command'	2022-09-28 15:45:16.205196+00
2004accb-0342-49e6-8dd3-39a5ba26d75f	2022-09-28 15:45:17.758543+00	2022-09-28 15:45:17.758549+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Executing 'trigger_dbt_cli_command-321ca940-1' immediately...	2022-09-28 15:45:16.205919+00
697e6997-d575-4f31-89f2-cc6d0ea4e386	2022-09-28 15:45:17.758559+00	2022-09-28 15:45:17.758564+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:45:16.232206+00
25d84f43-ed2c-4b37-bffa-b4c15816275f	2022-09-28 15:45:17.758573+00	2022-09-28 15:45:17.758578+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	Running dbt command: dbt run --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:45:16.232679+00
f43be9cd-b3e8-4a10-bf57-a1edb20f34b8	2022-09-28 15:45:19.784327+00	2022-09-28 15:45:19.784356+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  Running with dbt=1.2.1\n	2022-09-28 15:45:19.224893+00
56ce533e-efa0-45dc-ae36-4f6328c0afc9	2022-09-28 15:45:19.78437+00	2022-09-28 15:45:19.784376+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:45:19.363253+00
01f9177e-a887-4787-ab0e-d1ceefc5cc29	2022-09-28 15:45:19.784387+00	2022-09-28 15:45:19.784393+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  \n	2022-09-28 15:45:19.365219+00
29ce4244-9647-466f-85f3-b6403d52a15d	2022-09-28 15:45:19.784403+00	2022-09-28 15:45:19.784411+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  Concurrency: 4 threads (target='default')\n	2022-09-28 15:45:19.495632+00
ca5c2778-9cb4-42ae-9550-e7cdaefad125	2022-09-28 15:45:19.784422+00	2022-09-28 15:45:19.784427+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  \n	2022-09-28 15:45:19.496452+00
c43eee4e-b4e7-4911-bdf8-b7f8d9cea5b3	2022-09-28 15:45:19.784437+00	2022-09-28 15:45:19.784443+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  1 of 1 START table model sample.global_content_views ........................... [RUN]\n	2022-09-28 15:45:19.504955+00
f99fdaed-7096-4afd-8a44-7e9de83f7824	2022-09-28 15:45:19.784479+00	2022-09-28 15:45:19.784485+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  1 of 1 OK created table model sample.global_content_views ...................... [[32mSELECT 3[0m in 0.15s]\n	2022-09-28 15:45:19.656012+00
1acb09e3-d74e-427e-9750-2719c8beb49b	2022-09-28 15:45:19.784497+00	2022-09-28 15:45:19.784879+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  \n	2022-09-28 15:45:19.681338+00
8ebf9615-9684-44f7-b307-5352b1bc3032	2022-09-28 15:45:19.7849+00	2022-09-28 15:45:19.784904+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  Finished running 1 table model in 0 hours 0 minutes and 0.32 seconds (0.32s).\n	2022-09-28 15:45:19.681886+00
e68c9418-4cf7-4320-990c-06163ad6f246	2022-09-28 15:45:19.784912+00	2022-09-28 15:45:19.784916+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  \n	2022-09-28 15:45:19.691435+00
204fd8a5-43db-4f1c-892d-b3c12ffdb32d	2022-09-28 15:45:19.784923+00	2022-09-28 15:45:19.784927+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  [32mCompleted successfully[0m\n	2022-09-28 15:45:19.692353+00
2655d4e3-adee-4460-a871-c439b891247c	2022-09-28 15:45:19.784934+00	2022-09-28 15:45:19.784938+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  \n	2022-09-28 15:45:19.69282+00
4f8f6629-3d00-4873-a62c-12f7f9796f71	2022-09-28 15:45:19.784946+00	2022-09-28 15:45:19.784949+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	bdc6cccb-75ed-4109-bc0e-7e9cea02227f	[0m15:45:19  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1\n	2022-09-28 15:45:19.693179+00
42012b12-3760-410a-9bf7-b3bf65c87ce6	2022-09-28 15:45:23.814065+00	2022-09-28 15:45:23.814081+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	dbt test	2022-09-28 15:45:22.349145+00
57ccec16-181b-4e9d-ab11-cfd06ce998b7	2022-09-28 15:45:23.81409+00	2022-09-28 15:45:23.814094+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Created task run 'trigger_dbt_cli_command-321ca940-2' for task 'trigger_dbt_cli_command'	2022-09-28 15:45:22.374923+00
8ef4e1bd-3fbc-4278-a783-55f7f2b3a584	2022-09-28 15:45:23.814102+00	2022-09-28 15:45:23.814107+00	prefect.flow_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	\N	Executing 'trigger_dbt_cli_command-321ca940-2' immediately...	2022-09-28 15:45:22.375544+00
e315c893-e9c1-4435-acf4-c8818c046f98	2022-09-28 15:45:23.814114+00	2022-09-28 15:45:23.814118+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:45:22.401071+00
0d5ef9f0-27fd-4d13-a172-21118e541742	2022-09-28 15:45:23.814125+00	2022-09-28 15:45:23.814129+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	Running dbt command: dbt test --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:45:22.401563+00
706f113a-de53-4703-a739-c4aa03386b07	2022-09-28 15:48:51.557654+00	2022-09-28 15:48:51.557667+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	airbyte sync executed	2022-09-28 15:48:50.652188+00
d3afd6ae-550d-4857-9dbf-35453a520b65	2022-09-28 15:48:51.557676+00	2022-09-28 15:48:51.557681+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	get postgres profile	2022-09-28 15:48:50.65252+00
a8453ca3-2b5b-4440-a1da-375ce8e59082	2022-09-28 15:48:51.557688+00	2022-09-28 15:48:51.557692+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	dbt deps	2022-09-28 15:48:50.653024+00
15ff5fc0-b705-432f-a811-96e3fcecdb66	2022-09-28 15:48:51.557699+00	2022-09-28 15:48:51.557703+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Created task run 'trigger_dbt_cli_command-321ca940-0' for task 'trigger_dbt_cli_command'	2022-09-28 15:48:50.674255+00
bcdda474-a8a8-4a3f-b21e-016ccbcef59d	2022-09-28 15:48:51.557723+00	2022-09-28 15:48:51.557726+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Executing 'trigger_dbt_cli_command-321ca940-0' immediately...	2022-09-28 15:48:50.674546+00
b2e6adba-9daa-46f9-adea-4bd3b9ce15ab	2022-09-28 15:48:51.557734+00	2022-09-28 15:48:51.557737+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:48:50.692387+00
01d02969-0606-4357-b461-ed78c6800ba2	2022-09-28 15:48:51.557744+00	2022-09-28 15:48:51.557748+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	Running dbt command: dbt deps --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:48:50.692735+00
b0318f42-7d0c-4d92-8856-537c2b5e3391	2022-09-28 15:48:55.608879+00	2022-09-28 15:48:55.609051+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	[0m15:48:53  Installing dbt-labs/dbt_utils\n	2022-09-28 15:48:53.994797+00
f0616815-f689-409f-b0b7-5f34918fc176	2022-09-28 15:48:55.609081+00	2022-09-28 15:48:55.609098+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	[0m15:48:54    Installed from version 0.8.2\n	2022-09-28 15:48:54.636934+00
be5de9e6-7c7e-480c-9075-57355b745bbb	2022-09-28 15:48:55.609118+00	2022-09-28 15:48:55.609126+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	[0m15:48:54    Updated version available: 0.9.2\n[0m15:48:54  \n[0m15:48:54  Updates available for packages: ['dbt-labs/dbt_utils']                 \nUpdate your versions in packages.yml, then run dbt deps\n	2022-09-28 15:48:54.637835+00
c3c156d3-a6e2-49de-ac91-6e661b5f9875	2022-09-28 15:48:57.634085+00	2022-09-28 15:48:57.634097+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	dbt run	2022-09-28 15:48:57.020997+00
b8ce21a3-3c56-49f8-9af5-62c2299581aa	2022-09-28 15:48:57.634107+00	2022-09-28 15:48:57.634112+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Created task run 'trigger_dbt_cli_command-321ca940-1' for task 'trigger_dbt_cli_command'	2022-09-28 15:48:57.051653+00
bffd9764-4693-4ffe-bc86-449791c9a60c	2022-09-28 15:48:57.634119+00	2022-09-28 15:48:57.634123+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Executing 'trigger_dbt_cli_command-321ca940-1' immediately...	2022-09-28 15:48:57.052178+00
d14abfab-725f-4897-988f-db61d7e1a0cc	2022-09-28 15:48:57.63413+00	2022-09-28 15:48:57.634134+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:48:57.10025+00
b24d3c2d-75ea-4e6c-985f-f2941d174be9	2022-09-28 15:48:57.634141+00	2022-09-28 15:48:57.634144+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	Running dbt command: dbt run --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:48:57.100725+00
320780c1-c48c-494c-9481-94299184b7da	2022-09-28 15:49:03.705533+00	2022-09-28 15:49:03.70555+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	dbt test	2022-09-28 15:49:02.409306+00
5fe052bf-c8e6-4803-88a8-b11c02e55216	2022-09-28 15:49:03.705559+00	2022-09-28 15:49:03.705563+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Created task run 'trigger_dbt_cli_command-321ca940-2' for task 'trigger_dbt_cli_command'	2022-09-28 15:49:02.431944+00
c138803e-7cad-4085-bc99-ee86655797ab	2022-09-28 15:49:03.705571+00	2022-09-28 15:49:03.705575+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Executing 'trigger_dbt_cli_command-321ca940-2' immediately...	2022-09-28 15:49:02.43226+00
af64ac27-2f0c-41f9-a15f-47ec18da8e7d	2022-09-28 15:49:03.705582+00	2022-09-28 15:49:03.705586+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	Wrote profile to /root/.dbt/profiles.yml	2022-09-28 15:49:02.454378+00
627c0f37-6bca-4679-8ebd-a5a43e07314a	2022-09-28 15:49:03.705594+00	2022-09-28 15:49:03.705599+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	Running dbt command: dbt test --profiles-dir /root/.dbt --project-dir /root/flows/dbt_sample	2022-09-28 15:49:02.455262+00
c3e926ca-91fe-42fc-90de-9e09f202aec9	2022-09-28 15:45:25.842559+00	2022-09-28 15:45:25.842585+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  Running with dbt=1.2.1\n	2022-09-28 15:45:25.326318+00
0aa2cf71-6118-4754-b343-04514201d2c1	2022-09-28 15:45:25.842617+00	2022-09-28 15:45:25.842623+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:45:25.399905+00
84efc0b1-bcff-4320-9e40-75aff372f139	2022-09-28 15:45:25.842652+00	2022-09-28 15:45:25.842658+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  \n	2022-09-28 15:45:25.402043+00
d9ff675c-766a-47a0-99f6-d6e20393e097	2022-09-28 15:45:25.842667+00	2022-09-28 15:45:25.842672+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  Concurrency: 4 threads (target='default')\n	2022-09-28 15:45:25.501494+00
4293044c-2204-4631-a949-a80ed08517dd	2022-09-28 15:45:25.84268+00	2022-09-28 15:45:25.842685+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  \n	2022-09-28 15:45:25.502334+00
e2cd6398-916c-4e6a-9907-4e10e727cc83	2022-09-28 15:45:25.842694+00	2022-09-28 15:45:25.842699+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  1 of 2 START test not_null_global_content_views_id ............................. [RUN]\n	2022-09-28 15:45:25.508557+00
34d097b7-76d7-477a-8221-ee23fda8be84	2022-09-28 15:45:25.842709+00	2022-09-28 15:45:25.842714+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  2 of 2 START test unique_global_content_views_id ............................... [RUN]\n	2022-09-28 15:45:25.509299+00
fe3c26f6-06b6-43d6-9853-f60e4c76c0d0	2022-09-28 15:45:25.842723+00	2022-09-28 15:45:25.842728+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  1 of 2 PASS not_null_global_content_views_id ................................... [[32mPASS[0m in 0.08s]\n	2022-09-28 15:45:25.591115+00
c7aac911-705c-4023-add5-cac3eabd6aed	2022-09-28 15:45:25.842737+00	2022-09-28 15:45:25.842742+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  2 of 2 PASS unique_global_content_views_id ..................................... [[32mPASS[0m in 0.08s]\n	2022-09-28 15:45:25.59186+00
2dd460c9-f1fc-470a-be50-53e6739a7cbd	2022-09-28 15:45:25.842751+00	2022-09-28 15:45:25.842756+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  \n	2022-09-28 15:45:25.616279+00
643e2ccb-e8c7-4a77-8f01-baa075464f5c	2022-09-28 15:45:25.842766+00	2022-09-28 15:45:25.842771+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  Finished running 2 tests in 0 hours 0 minutes and 0.21 seconds (0.21s).\n	2022-09-28 15:45:25.616793+00
6fd8cabb-dca4-4fe1-9aa6-c22a996b4be7	2022-09-28 15:45:25.84278+00	2022-09-28 15:45:25.842785+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  \n	2022-09-28 15:45:25.628161+00
8de384c0-0e84-472c-8679-6e490bdac596	2022-09-28 15:45:25.842794+00	2022-09-28 15:45:25.842799+00	prefect.task_runs	20	a44524c8-7d21-4dfc-9478-54f7f083751e	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	[0m15:45:25  [32mCompleted successfully[0m\n[0m15:45:25  \n[0m15:45:25  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2\n	2022-09-28 15:45:25.62893+00
89e93299-af8b-4887-858c-a47040331043	2022-09-28 15:48:29.523492+00	2022-09-28 15:48:29.523513+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	trigger airbyte sync	2022-09-28 15:48:27.507932+00
f131e94b-74b0-4999-b529-eb8a903243ab	2022-09-28 15:48:29.523531+00	2022-09-28 15:48:29.523537+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Created task run 'trigger_sync-6dd98a16-0' for task 'trigger_sync'	2022-09-28 15:48:27.540273+00
55515f1f-c830-40d9-8d7e-abe091f75366	2022-09-28 15:48:29.523549+00	2022-09-28 15:48:29.523555+00	prefect.flow_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	\N	Executing 'trigger_sync-6dd98a16-0' immediately...	2022-09-28 15:48:27.540578+00
6408caae-d368-41c8-b184-4c9d787966d7	2022-09-28 15:48:53.579337+00	2022-09-28 15:48:53.57935+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	3c93ad19-90aa-4584-a923-dcad6d912d14	[0m15:48:53  Running with dbt=1.2.1\n	2022-09-28 15:48:53.29133+00
2781eaec-0865-4bbc-a8c5-60bdce3ce511	2022-09-28 15:48:59.655312+00	2022-09-28 15:48:59.655325+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  Running with dbt=1.2.1\n	2022-09-28 15:48:59.630966+00
ce47ceb8-19dc-45af-ad38-c7007aefa1b1	2022-09-28 15:49:01.672849+00	2022-09-28 15:49:01.672861+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:48:59.685637+00
ca475108-84fe-4e16-acc5-a21a4073b1e2	2022-09-28 15:49:01.67287+00	2022-09-28 15:49:01.672874+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  \n	2022-09-28 15:48:59.68667+00
1e89f483-f28b-469d-858d-0e907c5dfd35	2022-09-28 15:49:01.672881+00	2022-09-28 15:49:01.672884+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  Concurrency: 4 threads (target='default')\n	2022-09-28 15:48:59.775104+00
8e27eaa4-f09c-4a4c-b6cc-59bd3ba26620	2022-09-28 15:49:01.67289+00	2022-09-28 15:49:01.672894+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  \n	2022-09-28 15:48:59.77567+00
5fa002da-6c8f-4ec3-a8ae-db18b3f9217e	2022-09-28 15:49:01.6729+00	2022-09-28 15:49:01.672903+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  1 of 1 START table model sample.global_content_views ........................... [RUN]\n	2022-09-28 15:48:59.779477+00
d67c86dc-5892-4b75-a264-a03ea17820ea	2022-09-28 15:49:01.67291+00	2022-09-28 15:49:01.672913+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  1 of 1 OK created table model sample.global_content_views ...................... [[32mSELECT 3[0m in 0.10s]\n	2022-09-28 15:48:59.881771+00
b23b692e-1cb0-4a32-8991-31bb1662bc20	2022-09-28 15:49:01.672919+00	2022-09-28 15:49:01.672922+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  \n	2022-09-28 15:48:59.898518+00
bc69a743-37e4-440e-890c-27017b2b517e	2022-09-28 15:49:01.672929+00	2022-09-28 15:49:01.672932+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  Finished running 1 table model in 0 hours 0 minutes and 0.21 seconds (0.21s).\n	2022-09-28 15:48:59.899158+00
5125e77d-85d0-472c-8683-51d0a81a21c9	2022-09-28 15:49:01.672938+00	2022-09-28 15:49:01.672941+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  \n	2022-09-28 15:48:59.907919+00
4e6b75d9-c618-48c3-9ab5-cf3091ad3d76	2022-09-28 15:49:01.672948+00	2022-09-28 15:49:01.672951+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	6a8390cc-10fd-484a-b240-938a7096e242	[0m15:48:59  [32mCompleted successfully[0m\n[0m15:48:59  \n[0m15:48:59  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1\n	2022-09-28 15:48:59.908365+00
ecef2adb-afdc-42c0-a8ad-119ad1371ed7	2022-09-28 15:49:05.736082+00	2022-09-28 15:49:05.7361+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  Running with dbt=1.2.1\n	2022-09-28 15:49:05.58529+00
6ab8597a-f163-4fa0-9f2e-69a19e793c74	2022-09-28 15:49:05.736111+00	2022-09-28 15:49:05.736115+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  Found 1 model, 2 tests, 0 snapshots, 0 analyses, 458 macros, 0 operations, 0 seed files, 3 sources, 0 exposures, 0 metrics\n	2022-09-28 15:49:05.664479+00
bde6cfb0-d98a-4b37-b680-f18ab72bcdd6	2022-09-28 15:49:05.736122+00	2022-09-28 15:49:05.736126+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  \n	2022-09-28 15:49:05.666082+00
01236c7f-e2b8-4cd6-a223-3d6d476032a7	2022-09-28 15:49:07.757528+00	2022-09-28 15:49:07.757539+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  Concurrency: 4 threads (target='default')\n	2022-09-28 15:49:05.772245+00
dd88243d-7374-43d7-a265-f9111badb901	2022-09-28 15:49:07.757548+00	2022-09-28 15:49:07.757551+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  \n	2022-09-28 15:49:05.772789+00
1df52702-737b-4731-bc85-25de9e50b2c6	2022-09-28 15:49:07.757558+00	2022-09-28 15:49:07.757561+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  1 of 2 START test not_null_global_content_views_id ............................. [RUN]\n	2022-09-28 15:49:05.77881+00
709c065b-f1fd-4cc2-8344-ccbe5f121d92	2022-09-28 15:49:07.757568+00	2022-09-28 15:49:07.757571+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  2 of 2 START test unique_global_content_views_id ............................... [RUN]\n	2022-09-28 15:49:05.779261+00
0b5cf511-e8c1-40fe-a8e7-114a7bd05dcb	2022-09-28 15:49:07.757577+00	2022-09-28 15:49:07.757581+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  2 of 2 PASS unique_global_content_views_id ..................................... [[32mPASS[0m in 0.08s]\n	2022-09-28 15:49:05.856888+00
23e02ef9-be0e-48d1-ab51-eb7a79c24b80	2022-09-28 15:49:07.757587+00	2022-09-28 15:49:07.75759+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  1 of 2 PASS not_null_global_content_views_id ................................... [[32mPASS[0m in 0.08s]\n	2022-09-28 15:49:05.857423+00
a5cfad21-b6f6-41a3-9ab8-53c068bcb149	2022-09-28 15:49:07.757596+00	2022-09-28 15:49:07.757599+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  \n	2022-09-28 15:49:05.882337+00
c925136f-4bb3-4556-b966-8b0a3339b45e	2022-09-28 15:49:07.757606+00	2022-09-28 15:49:07.757609+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  Finished running 2 tests in 0 hours 0 minutes and 0.22 seconds (0.22s).\n	2022-09-28 15:49:05.882878+00
91a9fc3a-19a9-410c-b279-b134a1ea955a	2022-09-28 15:49:07.757615+00	2022-09-28 15:49:07.757619+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  \n	2022-09-28 15:49:05.893302+00
f1dfcdee-ce51-49f2-83bd-e48aedca2fc3	2022-09-28 15:49:07.757625+00	2022-09-28 15:49:07.757628+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  [32mCompleted successfully[0m\n	2022-09-28 15:49:05.893752+00
5b32ef03-e90a-427c-a70d-5a43ce599576	2022-09-28 15:49:07.757635+00	2022-09-28 15:49:07.757638+00	prefect.task_runs	20	3046a308-c64b-4a73-902a-a5546b6e5563	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	[0m15:49:05  \n[0m15:49:05  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2\n	2022-09-28 15:49:05.893971+00
\.


--
-- Data for Name: saved_search; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saved_search (id, created, updated, name, filters) FROM stdin;
\.


--
-- Data for Name: task_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_run (id, created, updated, name, state_type, run_count, expected_start_time, next_scheduled_start_time, start_time, end_time, total_run_time, task_key, dynamic_key, cache_key, cache_expiration, task_version, empirical_policy, task_inputs, tags, flow_run_id, state_id, state_name) FROM stdin;
8735a65e-d383-47e5-8343-6334fbab26b2	2022-09-28 02:30:33.900683+00	2022-09-28 02:31:00.422256+00	trigger_sync-6dd98a16-0	COMPLETED	1	2022-09-28 02:30:33.900483+00	\N	2022-09-28 02:30:33.927692+00	2022-09-28 02:31:00.42142+00	00:00:26.493728	prefect_airbyte.connections.trigger_sync	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"timeout": [], "connection_id": [], "status_updates": [], "poll_interval_s": [], "airbyte_api_version": [], "airbyte_server_host": [], "airbyte_server_port": []}	[]	1390466b-f913-47cd-85ce-6b5c1000afb0	854e4a67-0eed-4af7-9c0f-3567255fbe38	Completed
ab3953b1-c76b-412f-be62-5aaf6c2f57e4	2022-09-28 12:35:05.620478+00	2022-09-28 12:35:39.795425+00	trigger_sync-6dd98a16-0	COMPLETED	1	2022-09-28 12:35:05.620322+00	\N	2022-09-28 12:35:05.646923+00	2022-09-28 12:35:39.794595+00	00:00:34.147672	prefect_airbyte.connections.trigger_sync	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"timeout": [], "connection_id": [], "status_updates": [], "poll_interval_s": [], "airbyte_api_version": [], "airbyte_server_host": [], "airbyte_server_port": []}	[]	d9d33d26-e17d-4930-a659-1fc9b24c9142	5465bf07-2266-4e11-816f-5864d081ab52	Completed
50b8bc94-aac0-4bf1-9f6a-cb0adc268f71	2022-09-28 15:49:02.416605+00	2022-09-28 15:49:08.126067+00	trigger_dbt_cli_command-321ca940-2	COMPLETED	1	2022-09-28 15:49:02.416427+00	\N	2022-09-28 15:49:02.439404+00	2022-09-28 15:49:08.125197+00	00:00:05.685793	prefect_dbt.cli.commands.trigger_dbt_cli_command	2	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	3046a308-c64b-4a73-902a-a5546b6e5563	309dc2ac-7fa0-4270-bb8b-be589fb00aed	Completed
7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c	2022-09-28 15:44:35.618314+00	2022-09-28 15:45:09.244372+00	trigger_sync-6dd98a16-0	COMPLETED	1	2022-09-28 15:44:35.618186+00	\N	2022-09-28 15:44:35.64582+00	2022-09-28 15:45:09.243068+00	00:00:33.597248	prefect_airbyte.connections.trigger_sync	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"timeout": [], "connection_id": [], "status_updates": [], "poll_interval_s": [], "airbyte_api_version": [], "airbyte_server_host": [], "airbyte_server_port": []}	[]	a44524c8-7d21-4dfc-9478-54f7f083751e	7d637bd2-cd5e-47e4-938a-4e577c98e22b	Completed
025f15dc-90dd-4a5e-9ac4-c66d5d87568b	2022-09-28 15:45:09.269512+00	2022-09-28 15:45:16.165013+00	trigger_dbt_cli_command-321ca940-0	COMPLETED	1	2022-09-28 15:45:09.26919+00	\N	2022-09-28 15:45:09.300784+00	2022-09-28 15:45:16.1641+00	00:00:06.863316	prefect_dbt.cli.commands.trigger_dbt_cli_command	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	a44524c8-7d21-4dfc-9478-54f7f083751e	bc4a9bd7-eaeb-418b-b7b0-5674830a1b19	Completed
bdc6cccb-75ed-4109-bc0e-7e9cea02227f	2022-09-28 15:45:16.187568+00	2022-09-28 15:45:22.331792+00	trigger_dbt_cli_command-321ca940-1	COMPLETED	1	2022-09-28 15:45:16.187343+00	\N	2022-09-28 15:45:16.213866+00	2022-09-28 15:45:22.330133+00	00:00:06.116267	prefect_dbt.cli.commands.trigger_dbt_cli_command	1	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	a44524c8-7d21-4dfc-9478-54f7f083751e	4944a7ff-6415-410f-84b7-5b971f1d2821	Completed
99bc4ea4-0cfd-4ad0-9b89-376b488fc24c	2022-09-28 15:45:22.356262+00	2022-09-28 15:45:28.441196+00	trigger_dbt_cli_command-321ca940-2	COMPLETED	1	2022-09-28 15:45:22.355963+00	\N	2022-09-28 15:45:22.384768+00	2022-09-28 15:45:28.4403+00	00:00:06.055532	prefect_dbt.cli.commands.trigger_dbt_cli_command	2	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	a44524c8-7d21-4dfc-9478-54f7f083751e	259d778f-1e9c-44b7-8836-cb8c0738c006	Completed
a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97	2022-09-28 15:48:27.520913+00	2022-09-28 15:48:50.643306+00	trigger_sync-6dd98a16-0	COMPLETED	1	2022-09-28 15:48:27.520551+00	\N	2022-09-28 15:48:27.549409+00	2022-09-28 15:48:50.642608+00	00:00:23.093199	prefect_airbyte.connections.trigger_sync	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"timeout": [], "connection_id": [], "status_updates": [], "poll_interval_s": [], "airbyte_api_version": [], "airbyte_server_host": [], "airbyte_server_port": []}	[]	3046a308-c64b-4a73-902a-a5546b6e5563	c6459de7-a202-4cee-ab1d-bbfe243ac541	Completed
3c93ad19-90aa-4584-a923-dcad6d912d14	2022-09-28 15:48:50.663005+00	2022-09-28 15:48:56.998467+00	trigger_dbt_cli_command-321ca940-0	COMPLETED	1	2022-09-28 15:48:50.662887+00	\N	2022-09-28 15:48:50.679948+00	2022-09-28 15:48:56.997217+00	00:00:06.317269	prefect_dbt.cli.commands.trigger_dbt_cli_command	0	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	3046a308-c64b-4a73-902a-a5546b6e5563	0658d436-ec18-4668-a07e-dd4defd1f25f	Completed
6a8390cc-10fd-484a-b240-938a7096e242	2022-09-28 15:48:57.029135+00	2022-09-28 15:49:02.388367+00	trigger_dbt_cli_command-321ca940-1	COMPLETED	1	2022-09-28 15:48:57.028831+00	\N	2022-09-28 15:48:57.071999+00	2022-09-28 15:49:02.386758+00	00:00:05.314759	prefect_dbt.cli.commands.trigger_dbt_cli_command	1	\N	\N	\N	{"retries": 0, "max_retries": 0, "retry_delay": 0, "retry_delay_seconds": 0.0}	{"command": [], "project_dir": [], "profiles_dir": [], "dbt_cli_profile": [], "overwrite_profiles": [], "shell_run_command_kwargs": []}	[]	3046a308-c64b-4a73-902a-a5546b6e5563	7156fc48-9602-4abd-b623-53549eb6d2ea	Completed
\.


--
-- Data for Name: task_run_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_run_state (id, created, updated, type, "timestamp", name, message, state_details, data, task_run_id) FROM stdin;
9c644b27-2ccc-44c2-83fc-4cda499f2468	2022-09-28 02:30:33.908796+00	2022-09-28 02:30:33.908816+00	PENDING	2022-09-28 02:30:33.900483+00	Pending	\N	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": "8735a65e-d383-47e5-8343-6334fbab26b2", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	8735a65e-d383-47e5-8343-6334fbab26b2
e4599d38-af62-4829-a534-870d7e3a89e5	2022-09-28 02:30:33.93397+00	2022-09-28 02:30:33.93398+00	RUNNING	2022-09-28 02:30:33.927692+00	Running	\N	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": "8735a65e-d383-47e5-8343-6334fbab26b2", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	8735a65e-d383-47e5-8343-6334fbab26b2
854e4a67-0eed-4af7-9c0f-3567255fbe38	2022-09-28 02:31:00.431398+00	2022-09-28 02:31:00.43143+00	COMPLETED	2022-09-28 02:31:00.42142+00	Completed	\N	{"cache_key": null, "flow_run_id": "1390466b-f913-47cd-85ce-6b5c1000afb0", "task_run_id": "8735a65e-d383-47e5-8343-6334fbab26b2", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"af929ac2d7b3458ab25a671d8466dc25\\", \\"filesystem_document_id\\": \\"a09d06ec-f077-4e66-ab75-f1d3f2d2aec7\\"}", "encoding": "result"}	8735a65e-d383-47e5-8343-6334fbab26b2
53cad219-7fe0-421b-963e-28e5d35596a4	2022-09-28 12:35:05.62855+00	2022-09-28 12:35:05.6286+00	PENDING	2022-09-28 12:35:05.620322+00	Pending	\N	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": "ab3953b1-c76b-412f-be62-5aaf6c2f57e4", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	ab3953b1-c76b-412f-be62-5aaf6c2f57e4
3ff4466b-3842-43ac-94aa-5aae2903df65	2022-09-28 12:35:05.652829+00	2022-09-28 12:35:05.652865+00	RUNNING	2022-09-28 12:35:05.646923+00	Running	\N	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": "ab3953b1-c76b-412f-be62-5aaf6c2f57e4", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	ab3953b1-c76b-412f-be62-5aaf6c2f57e4
5465bf07-2266-4e11-816f-5864d081ab52	2022-09-28 12:35:39.799167+00	2022-09-28 12:35:39.799183+00	COMPLETED	2022-09-28 12:35:39.794595+00	Completed	\N	{"cache_key": null, "flow_run_id": "d9d33d26-e17d-4930-a659-1fc9b24c9142", "task_run_id": "ab3953b1-c76b-412f-be62-5aaf6c2f57e4", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"fe3813f77ed048599d526c6c555f23cf\\", \\"filesystem_document_id\\": \\"019b0990-5aaf-408f-82ce-9e318f212918\\"}", "encoding": "result"}	ab3953b1-c76b-412f-be62-5aaf6c2f57e4
363a7d6d-58ed-49cc-96dd-7cac4c077720	2022-09-28 15:44:35.62786+00	2022-09-28 15:44:35.627877+00	PENDING	2022-09-28 15:44:35.618186+00	Pending	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c
4944a7ff-6415-410f-84b7-5b971f1d2821	2022-09-28 15:45:22.334743+00	2022-09-28 15:45:22.334758+00	COMPLETED	2022-09-28 15:45:22.330133+00	Completed	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "bdc6cccb-75ed-4109-bc0e-7e9cea02227f", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"adee6bbc7e714fec9bdda71e0af0570c\\", \\"filesystem_document_id\\": \\"c3356fbf-7634-46f4-b6ec-0b0b8047ff80\\"}", "encoding": "result"}	bdc6cccb-75ed-4109-bc0e-7e9cea02227f
bc06e094-6a0e-4255-ab4d-4778a5fda2b8	2022-09-28 15:45:09.278873+00	2022-09-28 15:45:09.278891+00	PENDING	2022-09-28 15:45:09.26919+00	Pending	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "025f15dc-90dd-4a5e-9ac4-c66d5d87568b", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	025f15dc-90dd-4a5e-9ac4-c66d5d87568b
bc4a9bd7-eaeb-418b-b7b0-5674830a1b19	2022-09-28 15:45:16.169053+00	2022-09-28 15:45:16.169067+00	COMPLETED	2022-09-28 15:45:16.1641+00	Completed	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "025f15dc-90dd-4a5e-9ac4-c66d5d87568b", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"575313d356fd45d9bcc5cfec29b77c9b\\", \\"filesystem_document_id\\": \\"c3356fbf-7634-46f4-b6ec-0b0b8047ff80\\"}", "encoding": "result"}	025f15dc-90dd-4a5e-9ac4-c66d5d87568b
68df16c9-e99b-4927-90cc-d6b5fd8305f2	2022-09-28 15:45:22.39052+00	2022-09-28 15:45:22.39054+00	RUNNING	2022-09-28 15:45:22.384768+00	Running	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "99bc4ea4-0cfd-4ad0-9b89-376b488fc24c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c
259d778f-1e9c-44b7-8836-cb8c0738c006	2022-09-28 15:45:28.444701+00	2022-09-28 15:45:28.444714+00	COMPLETED	2022-09-28 15:45:28.4403+00	Completed	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "99bc4ea4-0cfd-4ad0-9b89-376b488fc24c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"367fd6482bfc4664a53c12face45cc94\\", \\"filesystem_document_id\\": \\"c3356fbf-7634-46f4-b6ec-0b0b8047ff80\\"}", "encoding": "result"}	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c
71718977-d067-41a3-b474-049ae2ef18a8	2022-09-28 15:44:35.650232+00	2022-09-28 15:44:35.650245+00	RUNNING	2022-09-28 15:44:35.64582+00	Running	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c
7d637bd2-cd5e-47e4-938a-4e577c98e22b	2022-09-28 15:45:09.247949+00	2022-09-28 15:45:09.247977+00	COMPLETED	2022-09-28 15:45:09.243068+00	Completed	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"fe5e510a3703427caa341e48ad1cee76\\", \\"filesystem_document_id\\": \\"c3356fbf-7634-46f4-b6ec-0b0b8047ff80\\"}", "encoding": "result"}	7311fd2f-d9bf-465d-b20f-0d1f69bc5d8c
4347e4c1-b29d-4717-a37c-f7bf1c5da39f	2022-09-28 15:45:22.364909+00	2022-09-28 15:45:22.364931+00	PENDING	2022-09-28 15:45:22.355963+00	Pending	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "99bc4ea4-0cfd-4ad0-9b89-376b488fc24c", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	99bc4ea4-0cfd-4ad0-9b89-376b488fc24c
57d8e6fd-e250-4e55-9060-cbec5f18ceff	2022-09-28 15:45:16.222149+00	2022-09-28 15:45:16.222163+00	RUNNING	2022-09-28 15:45:16.213866+00	Running	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "bdc6cccb-75ed-4109-bc0e-7e9cea02227f", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	bdc6cccb-75ed-4109-bc0e-7e9cea02227f
a0ae6f3e-f579-4296-9ce2-59ccb0ee1cce	2022-09-28 15:45:09.308807+00	2022-09-28 15:45:09.308827+00	RUNNING	2022-09-28 15:45:09.300784+00	Running	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "025f15dc-90dd-4a5e-9ac4-c66d5d87568b", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	025f15dc-90dd-4a5e-9ac4-c66d5d87568b
9c17661a-f651-453e-a3a6-d09d96f11fbf	2022-09-28 15:45:16.195917+00	2022-09-28 15:45:16.195936+00	PENDING	2022-09-28 15:45:16.187343+00	Pending	\N	{"cache_key": null, "flow_run_id": "a44524c8-7d21-4dfc-9478-54f7f083751e", "task_run_id": "bdc6cccb-75ed-4109-bc0e-7e9cea02227f", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	bdc6cccb-75ed-4109-bc0e-7e9cea02227f
dc490377-6a53-4adc-b4b8-2016b5130a63	2022-09-28 15:48:27.529622+00	2022-09-28 15:48:27.529644+00	PENDING	2022-09-28 15:48:27.520551+00	Pending	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97
0b200c00-654f-4c78-96c5-90bd0d302d50	2022-09-28 15:48:27.555961+00	2022-09-28 15:48:27.555976+00	RUNNING	2022-09-28 15:48:27.549409+00	Running	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97
c6459de7-a202-4cee-ab1d-bbfe243ac541	2022-09-28 15:48:50.645619+00	2022-09-28 15:48:50.64563+00	COMPLETED	2022-09-28 15:48:50.642608+00	Completed	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"b3968e28b28042b2b5173efd6ec963ab\\", \\"filesystem_document_id\\": \\"ab0be542-6ad7-47b8-8570-422c482b1daa\\"}", "encoding": "result"}	a3c9abd1-ac46-4f7b-aaf2-a2da598f5e97
dad71ea9-9741-4153-b824-24a3c8270fd8	2022-09-28 15:48:50.667726+00	2022-09-28 15:48:50.667737+00	PENDING	2022-09-28 15:48:50.662887+00	Pending	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "3c93ad19-90aa-4584-a923-dcad6d912d14", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3c93ad19-90aa-4584-a923-dcad6d912d14
af746f1c-61fa-474b-a29d-2dc046cc1911	2022-09-28 15:48:50.685187+00	2022-09-28 15:48:50.685199+00	RUNNING	2022-09-28 15:48:50.679948+00	Running	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "3c93ad19-90aa-4584-a923-dcad6d912d14", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	3c93ad19-90aa-4584-a923-dcad6d912d14
0658d436-ec18-4668-a07e-dd4defd1f25f	2022-09-28 15:48:57.005202+00	2022-09-28 15:48:57.005224+00	COMPLETED	2022-09-28 15:48:56.997217+00	Completed	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "3c93ad19-90aa-4584-a923-dcad6d912d14", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"a7773885166f459e8d589d304e698dc9\\", \\"filesystem_document_id\\": \\"ab0be542-6ad7-47b8-8570-422c482b1daa\\"}", "encoding": "result"}	3c93ad19-90aa-4584-a923-dcad6d912d14
c03457b5-18f1-446a-ba78-1a873a6834d5	2022-09-28 15:48:57.040574+00	2022-09-28 15:48:57.040603+00	PENDING	2022-09-28 15:48:57.028831+00	Pending	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "6a8390cc-10fd-484a-b240-938a7096e242", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6a8390cc-10fd-484a-b240-938a7096e242
3fd923fe-8d7b-427c-bddd-a2f61fec609e	2022-09-28 15:48:57.082177+00	2022-09-28 15:48:57.082212+00	RUNNING	2022-09-28 15:48:57.071999+00	Running	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "6a8390cc-10fd-484a-b240-938a7096e242", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	6a8390cc-10fd-484a-b240-938a7096e242
7156fc48-9602-4abd-b623-53549eb6d2ea	2022-09-28 15:49:02.391753+00	2022-09-28 15:49:02.391766+00	COMPLETED	2022-09-28 15:49:02.386758+00	Completed	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "6a8390cc-10fd-484a-b240-938a7096e242", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"6691921298f0475a8474a159105b28b6\\", \\"filesystem_document_id\\": \\"ab0be542-6ad7-47b8-8570-422c482b1daa\\"}", "encoding": "result"}	6a8390cc-10fd-484a-b240-938a7096e242
03e9e10f-6d22-48f1-bd70-74a67966171d	2022-09-28 15:49:02.422853+00	2022-09-28 15:49:02.422899+00	PENDING	2022-09-28 15:49:02.416427+00	Pending	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "50b8bc94-aac0-4bf1-9f6a-cb0adc268f71", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71
37ab3f3e-279e-4e0b-91e2-a78addffbf27	2022-09-28 15:49:02.444816+00	2022-09-28 15:49:02.444829+00	RUNNING	2022-09-28 15:49:02.439404+00	Running	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "50b8bc94-aac0-4bf1-9f6a-cb0adc268f71", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	\N	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71
309dc2ac-7fa0-4270-bb8b-be589fb00aed	2022-09-28 15:49:08.12956+00	2022-09-28 15:49:08.129572+00	COMPLETED	2022-09-28 15:49:08.125197+00	Completed	\N	{"cache_key": null, "flow_run_id": "3046a308-c64b-4a73-902a-a5546b6e5563", "task_run_id": "50b8bc94-aac0-4bf1-9f6a-cb0adc268f71", "scheduled_time": null, "cache_expiration": null, "child_flow_run_id": null, "untrackable_result": false}	{"blob": "{\\"key\\": \\"ea3d7fd7451345e78bf0f898d0a980a9\\", \\"filesystem_document_id\\": \\"ab0be542-6ad7-47b8-8570-422c482b1daa\\"}", "encoding": "result"}	50b8bc94-aac0-4bf1-9f6a-cb0adc268f71
\.


--
-- Data for Name: task_run_state_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_run_state_cache (id, created, updated, cache_key, cache_expiration, task_run_state_id) FROM stdin;
\.


--
-- Data for Name: work_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_queue (id, created, updated, name, filter, description, is_paused, concurrency_limit) FROM stdin;
88e026ab-23a9-4fda-97ac-85b9e709004e	2022-09-19 00:02:53.789668+00	2022-09-19 00:02:53.789684+00	my_queue	\N		f	\N
\.


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: agent pk_agent; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT pk_agent PRIMARY KEY (id);


--
-- Name: block_document pk_block_document; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document
    ADD CONSTRAINT pk_block_document PRIMARY KEY (id);


--
-- Name: block_document_reference pk_block_document_reference; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document_reference
    ADD CONSTRAINT pk_block_document_reference PRIMARY KEY (id);


--
-- Name: block_schema pk_block_schema; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_schema
    ADD CONSTRAINT pk_block_schema PRIMARY KEY (id);


--
-- Name: block_schema_reference pk_block_schema_reference; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_schema_reference
    ADD CONSTRAINT pk_block_schema_reference PRIMARY KEY (id);


--
-- Name: block_type pk_block_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_type
    ADD CONSTRAINT pk_block_type PRIMARY KEY (id);


--
-- Name: concurrency_limit pk_concurrency_limit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concurrency_limit
    ADD CONSTRAINT pk_concurrency_limit PRIMARY KEY (id);


--
-- Name: configuration pk_configuration; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT pk_configuration PRIMARY KEY (id);


--
-- Name: deployment pk_deployment; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployment
    ADD CONSTRAINT pk_deployment PRIMARY KEY (id);


--
-- Name: flow pk_flow; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow
    ADD CONSTRAINT pk_flow PRIMARY KEY (id);


--
-- Name: flow_run pk_flow_run; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT pk_flow_run PRIMARY KEY (id);


--
-- Name: flow_run_notification_policy pk_flow_run_notification_policy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run_notification_policy
    ADD CONSTRAINT pk_flow_run_notification_policy PRIMARY KEY (id);


--
-- Name: flow_run_notification_queue pk_flow_run_notification_queue; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run_notification_queue
    ADD CONSTRAINT pk_flow_run_notification_queue PRIMARY KEY (id);


--
-- Name: flow_run_state pk_flow_run_state; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run_state
    ADD CONSTRAINT pk_flow_run_state PRIMARY KEY (id);


--
-- Name: log pk_log; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT pk_log PRIMARY KEY (id);


--
-- Name: saved_search pk_saved_search; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_search
    ADD CONSTRAINT pk_saved_search PRIMARY KEY (id);


--
-- Name: task_run pk_task_run; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run
    ADD CONSTRAINT pk_task_run PRIMARY KEY (id);


--
-- Name: task_run_state pk_task_run_state; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run_state
    ADD CONSTRAINT pk_task_run_state PRIMARY KEY (id);


--
-- Name: task_run_state_cache pk_task_run_state_cache; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run_state_cache
    ADD CONSTRAINT pk_task_run_state_cache PRIMARY KEY (id);


--
-- Name: work_queue pk_work_queue; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_queue
    ADD CONSTRAINT pk_work_queue PRIMARY KEY (id);


--
-- Name: agent uq_agent__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT uq_agent__name UNIQUE (name);


--
-- Name: configuration uq_configuration__key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT uq_configuration__key UNIQUE (key);


--
-- Name: flow uq_flow__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow
    ADD CONSTRAINT uq_flow__name UNIQUE (name);


--
-- Name: saved_search uq_saved_search__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_search
    ADD CONSTRAINT uq_saved_search__name UNIQUE (name);


--
-- Name: work_queue uq_work_queue__name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_queue
    ADD CONSTRAINT uq_work_queue__name UNIQUE (name);


--
-- Name: ix_agent__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_agent__updated ON public.agent USING btree (updated);


--
-- Name: ix_agent__work_queue_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_agent__work_queue_id ON public.agent USING btree (work_queue_id);


--
-- Name: ix_block_document__is_anonymous; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_document__is_anonymous ON public.block_document USING btree (is_anonymous);


--
-- Name: ix_block_document__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_document__name ON public.block_document USING btree (name);


--
-- Name: ix_block_document__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_document__updated ON public.block_document USING btree (updated);


--
-- Name: ix_block_document_reference__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_document_reference__updated ON public.block_document_reference USING btree (updated);


--
-- Name: ix_block_schema__block_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_schema__block_type_id ON public.block_schema USING btree (block_type_id);


--
-- Name: ix_block_schema__capabilities; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_schema__capabilities ON public.block_schema USING gin (capabilities);


--
-- Name: ix_block_schema__created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_schema__created ON public.block_schema USING btree (created);


--
-- Name: ix_block_schema__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_schema__updated ON public.block_schema USING btree (updated);


--
-- Name: ix_block_schema_reference__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_schema_reference__updated ON public.block_schema_reference USING btree (updated);


--
-- Name: ix_block_type__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_block_type__updated ON public.block_type USING btree (updated);


--
-- Name: ix_concurrency_limit__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_concurrency_limit__updated ON public.concurrency_limit USING btree (updated);


--
-- Name: ix_configuration__key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_configuration__key ON public.configuration USING btree (key);


--
-- Name: ix_configuration__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_configuration__updated ON public.configuration USING btree (updated);


--
-- Name: ix_deployment__flow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_deployment__flow_id ON public.deployment USING btree (flow_id);


--
-- Name: ix_deployment__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_deployment__updated ON public.deployment USING btree (updated);


--
-- Name: ix_deployment__work_queue_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_deployment__work_queue_name ON public.deployment USING btree (work_queue_name);


--
-- Name: ix_flow__created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow__created ON public.flow USING btree (created);


--
-- Name: ix_flow__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow__updated ON public.flow USING btree (updated);


--
-- Name: ix_flow_run__deployment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__deployment_id ON public.flow_run USING btree (deployment_id);


--
-- Name: ix_flow_run__end_time_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__end_time_desc ON public.flow_run USING btree (end_time DESC);


--
-- Name: ix_flow_run__expected_start_time_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__expected_start_time_desc ON public.flow_run USING btree (expected_start_time DESC);


--
-- Name: ix_flow_run__flow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__flow_id ON public.flow_run USING btree (flow_id);


--
-- Name: ix_flow_run__flow_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__flow_version ON public.flow_run USING btree (flow_version);


--
-- Name: ix_flow_run__infrastructure_document_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__infrastructure_document_id ON public.flow_run USING btree (infrastructure_document_id);


--
-- Name: ix_flow_run__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__name ON public.flow_run USING btree (name);


--
-- Name: ix_flow_run__next_scheduled_start_time_asc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__next_scheduled_start_time_asc ON public.flow_run USING btree (next_scheduled_start_time);


--
-- Name: ix_flow_run__parent_task_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__parent_task_run_id ON public.flow_run USING btree (parent_task_run_id);


--
-- Name: ix_flow_run__start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__start_time ON public.flow_run USING btree (start_time);


--
-- Name: ix_flow_run__state_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__state_id ON public.flow_run USING btree (state_id);


--
-- Name: ix_flow_run__state_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__state_name ON public.flow_run USING btree (state_name);


--
-- Name: ix_flow_run__state_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__state_type ON public.flow_run USING btree (state_type);


--
-- Name: ix_flow_run__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__updated ON public.flow_run USING btree (updated);


--
-- Name: ix_flow_run__work_queue_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run__work_queue_name ON public.flow_run USING btree (work_queue_name);


--
-- Name: ix_flow_run_notification_policy__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run_notification_policy__updated ON public.flow_run_notification_policy USING btree (updated);


--
-- Name: ix_flow_run_notification_queue__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run_notification_queue__updated ON public.flow_run_notification_queue USING btree (updated);


--
-- Name: ix_flow_run_state__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run_state__name ON public.flow_run_state USING btree (name);


--
-- Name: ix_flow_run_state__type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run_state__type ON public.flow_run_state USING btree (type);


--
-- Name: ix_flow_run_state__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_flow_run_state__updated ON public.flow_run_state USING btree (updated);


--
-- Name: ix_log__flow_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log__flow_run_id ON public.log USING btree (flow_run_id);


--
-- Name: ix_log__level; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log__level ON public.log USING btree (level);


--
-- Name: ix_log__task_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log__task_run_id ON public.log USING btree (task_run_id);


--
-- Name: ix_log__timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log__timestamp ON public.log USING btree ("timestamp");


--
-- Name: ix_log__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log__updated ON public.log USING btree (updated);


--
-- Name: ix_saved_search__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_saved_search__updated ON public.saved_search USING btree (updated);


--
-- Name: ix_task_run__end_time_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__end_time_desc ON public.task_run USING btree (end_time DESC);


--
-- Name: ix_task_run__expected_start_time_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__expected_start_time_desc ON public.task_run USING btree (expected_start_time DESC);


--
-- Name: ix_task_run__flow_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__flow_run_id ON public.task_run USING btree (flow_run_id);


--
-- Name: ix_task_run__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__name ON public.task_run USING btree (name);


--
-- Name: ix_task_run__next_scheduled_start_time_asc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__next_scheduled_start_time_asc ON public.task_run USING btree (next_scheduled_start_time);


--
-- Name: ix_task_run__start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__start_time ON public.task_run USING btree (start_time);


--
-- Name: ix_task_run__state_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__state_id ON public.task_run USING btree (state_id);


--
-- Name: ix_task_run__state_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__state_name ON public.task_run USING btree (state_name);


--
-- Name: ix_task_run__state_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__state_type ON public.task_run USING btree (state_type);


--
-- Name: ix_task_run__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run__updated ON public.task_run USING btree (updated);


--
-- Name: ix_task_run_state__name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run_state__name ON public.task_run_state USING btree (name);


--
-- Name: ix_task_run_state__type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run_state__type ON public.task_run_state USING btree (type);


--
-- Name: ix_task_run_state__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run_state__updated ON public.task_run_state USING btree (updated);


--
-- Name: ix_task_run_state_cache__cache_key_created_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run_state_cache__cache_key_created_desc ON public.task_run_state_cache USING btree (cache_key, created DESC);


--
-- Name: ix_task_run_state_cache__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_run_state_cache__updated ON public.task_run_state_cache USING btree (updated);


--
-- Name: ix_work_queue__updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_work_queue__updated ON public.work_queue USING btree (updated);


--
-- Name: trgm_ix_block_type_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trgm_ix_block_type_name ON public.block_type USING gin (name public.gin_trgm_ops);


--
-- Name: trgm_ix_deployment_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trgm_ix_deployment_name ON public.deployment USING gin (name public.gin_trgm_ops);


--
-- Name: trgm_ix_flow_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trgm_ix_flow_name ON public.flow USING gin (name public.gin_trgm_ops);


--
-- Name: trgm_ix_flow_run_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trgm_ix_flow_run_name ON public.flow_run USING gin (name public.gin_trgm_ops);


--
-- Name: trgm_ix_task_run_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trgm_ix_task_run_name ON public.task_run USING gin (name public.gin_trgm_ops);


--
-- Name: uq_block__type_id_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_block__type_id_name ON public.block_document USING btree (block_type_id, name);


--
-- Name: uq_block_schema__checksum_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_block_schema__checksum_version ON public.block_schema USING btree (checksum, version);


--
-- Name: uq_block_type__slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_block_type__slug ON public.block_type USING btree (slug);


--
-- Name: uq_concurrency_limit__tag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_concurrency_limit__tag ON public.concurrency_limit USING btree (tag);


--
-- Name: uq_deployment__flow_id_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_deployment__flow_id_name ON public.deployment USING btree (flow_id, name);


--
-- Name: uq_flow_run__flow_id_idempotency_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_flow_run__flow_id_idempotency_key ON public.flow_run USING btree (flow_id, idempotency_key);


--
-- Name: uq_flow_run_state__flow_run_id_timestamp_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_flow_run_state__flow_run_id_timestamp_desc ON public.flow_run_state USING btree (flow_run_id, "timestamp" DESC);


--
-- Name: uq_task_run__flow_run_id_task_key_dynamic_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_task_run__flow_run_id_task_key_dynamic_key ON public.task_run USING btree (flow_run_id, task_key, dynamic_key);


--
-- Name: uq_task_run_state__task_run_id_timestamp_desc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_task_run_state__task_run_id_timestamp_desc ON public.task_run_state USING btree (task_run_id, "timestamp" DESC);


--
-- Name: agent fk_agent__work_queue_id__work_queue; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT fk_agent__work_queue_id__work_queue FOREIGN KEY (work_queue_id) REFERENCES public.work_queue(id);


--
-- Name: block_document fk_block__block_schema_id__block_schema; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document
    ADD CONSTRAINT fk_block__block_schema_id__block_schema FOREIGN KEY (block_schema_id) REFERENCES public.block_schema(id) ON DELETE CASCADE;


--
-- Name: block_document fk_block_document__block_type_id__block_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document
    ADD CONSTRAINT fk_block_document__block_type_id__block_type FOREIGN KEY (block_type_id) REFERENCES public.block_type(id) ON DELETE CASCADE;


--
-- Name: block_document_reference fk_block_document_reference__parent_block_document_id___328f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document_reference
    ADD CONSTRAINT fk_block_document_reference__parent_block_document_id___328f FOREIGN KEY (parent_block_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: block_document_reference fk_block_document_reference__reference_block_document_i_5759; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_document_reference
    ADD CONSTRAINT fk_block_document_reference__reference_block_document_i_5759 FOREIGN KEY (reference_block_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: block_schema fk_block_schema__block_type_id__block_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_schema
    ADD CONSTRAINT fk_block_schema__block_type_id__block_type FOREIGN KEY (block_type_id) REFERENCES public.block_type(id) ON DELETE CASCADE;


--
-- Name: block_schema_reference fk_block_schema_reference__parent_block_schema_id__block_schema; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_schema_reference
    ADD CONSTRAINT fk_block_schema_reference__parent_block_schema_id__block_schema FOREIGN KEY (parent_block_schema_id) REFERENCES public.block_schema(id) ON DELETE CASCADE;


--
-- Name: block_schema_reference fk_block_schema_reference__reference_block_schema_id__b_6e5d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.block_schema_reference
    ADD CONSTRAINT fk_block_schema_reference__reference_block_schema_id__b_6e5d FOREIGN KEY (reference_block_schema_id) REFERENCES public.block_schema(id) ON DELETE CASCADE;


--
-- Name: deployment fk_deployment__flow_id__flow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployment
    ADD CONSTRAINT fk_deployment__flow_id__flow FOREIGN KEY (flow_id) REFERENCES public.flow(id) ON DELETE CASCADE;


--
-- Name: deployment fk_deployment__infrastructure_document_id__block_document; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployment
    ADD CONSTRAINT fk_deployment__infrastructure_document_id__block_document FOREIGN KEY (infrastructure_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: deployment fk_deployment__storage_document_id__block_document; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployment
    ADD CONSTRAINT fk_deployment__storage_document_id__block_document FOREIGN KEY (storage_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: flow_run fk_flow_run__deployment_id__deployment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT fk_flow_run__deployment_id__deployment FOREIGN KEY (deployment_id) REFERENCES public.deployment(id) ON DELETE SET NULL;


--
-- Name: flow_run fk_flow_run__flow_id__flow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT fk_flow_run__flow_id__flow FOREIGN KEY (flow_id) REFERENCES public.flow(id) ON DELETE CASCADE;


--
-- Name: flow_run fk_flow_run__infrastructure_document_id__block_document; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT fk_flow_run__infrastructure_document_id__block_document FOREIGN KEY (infrastructure_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: flow_run fk_flow_run__parent_task_run_id__task_run; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT fk_flow_run__parent_task_run_id__task_run FOREIGN KEY (parent_task_run_id) REFERENCES public.task_run(id) ON DELETE SET NULL;


--
-- Name: flow_run fk_flow_run__state_id__flow_run_state; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run
    ADD CONSTRAINT fk_flow_run__state_id__flow_run_state FOREIGN KEY (state_id) REFERENCES public.flow_run_state(id) ON DELETE SET NULL;


--
-- Name: flow_run_notification_policy fk_flow_run_alert_policy__block_document_id__block_document; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run_notification_policy
    ADD CONSTRAINT fk_flow_run_alert_policy__block_document_id__block_document FOREIGN KEY (block_document_id) REFERENCES public.block_document(id) ON DELETE CASCADE;


--
-- Name: flow_run_state fk_flow_run_state__flow_run_id__flow_run; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_run_state
    ADD CONSTRAINT fk_flow_run_state__flow_run_id__flow_run FOREIGN KEY (flow_run_id) REFERENCES public.flow_run(id) ON DELETE CASCADE;


--
-- Name: task_run fk_task_run__flow_run_id__flow_run; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run
    ADD CONSTRAINT fk_task_run__flow_run_id__flow_run FOREIGN KEY (flow_run_id) REFERENCES public.flow_run(id) ON DELETE CASCADE;


--
-- Name: task_run fk_task_run__state_id__task_run_state; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run
    ADD CONSTRAINT fk_task_run__state_id__task_run_state FOREIGN KEY (state_id) REFERENCES public.task_run_state(id) ON DELETE SET NULL;


--
-- Name: task_run_state fk_task_run_state__task_run_id__task_run; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_run_state
    ADD CONSTRAINT fk_task_run_state__task_run_id__task_run FOREIGN KEY (task_run_id) REFERENCES public.task_run(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

