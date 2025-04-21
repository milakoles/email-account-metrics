CREATE OR REPLACE VIEW
  `Students.v_kolesnyk_metrics` AS
WITH
  account_data AS ( -- accounts
  SELECT
    s.date AS date,
    sp.country AS country,
    a.send_interval AS send_interval,
    a.is_verified AS is_verified,
    a.is_unsubscribed AS is_unsubscribed,
    COUNT(DISTINCT a.id) AS account_cnt,
    0 AS sent_msg,
    0 AS open_msg,
    0 AS visit_msg
  FROM
    `DA.session_params` sp
  JOIN
    `DA.session` s
  ON
    sp.ga_session_id = s.ga_session_id
  JOIN
    `DA.account_session` acs
  ON
    acs.ga_session_id = s.ga_session_id
  JOIN
    `DA.account` a
  ON
    a.id = acs.account_id
  GROUP BY
    s.date,
    sp.country,
    a.send_interval,
    a.is_verified,
    a.is_unsubscribed),
  email_data AS( -- email--metriks
  SELECT
    s.date AS date,
    sp.country AS country,
    NULL AS send_interval,
    NULL AS is_verified,
    NULL AS is_unsubscribed,
    0 AS account_cnt,
    COUNT(es.id_message) AS sent_msg,
    COUNT(eo.id_message) AS open_msg,
    COUNT(ev.id_message) AS visit_msg
  FROM
    `DA.email_sent` es
  JOIN
    `DA.account` a
  ON
    a.id = es.id_account
  LEFT JOIN
    `DA.email_open` eo
  ON
    es.id_message = eo.id_message
  LEFT JOIN
    `DA.email_visit` ev
  ON
    ev.id_message = es.id_message
  JOIN
    `DA.account_session` acs
  ON
    acs.account_id = a.id
  JOIN
    `DA.session` s
  ON
    s.ga_session_id = acs.ga_session_id
  JOIN
    `DA.session_params` sp
  ON
    s.ga_session_id = sp.ga_session_id
  GROUP BY
    s.date,
    sp.country ),


   
  union_acc_email_data AS( -- Union--data
  SELECT
    *
  FROM
    account_data
  UNION ALL
  SELECT
    *
  FROM
    email_data ),
  rank_data AS ( -- calculate accounts
  SELECT
    country,
    SUM(account_cnt) AS total_country_account_cnt,
    SUM(sent_msg) AS total_country_sent_cnt,
    DENSE_RANK() OVER (ORDER BY SUM(account_cnt) DESC) AS rank_total_country_account_cnt,
    DENSE_RANK() OVER (ORDER BY SUM(sent_msg) DESC) AS rank_total_country_sent_cnt
  FROM
    union_acc_email_data
  GROUP BY
    country ) -- final requst top 10 
SELECT
  u.date,
  u.country,
  u.send_interval,
  u.is_verified,
  u.is_unsubscribed,
  u.account_cnt,
  u.sent_msg,
  u.open_msg,
  u.visit_msg,
  r.total_country_account_cnt,
  r.total_country_sent_cnt,
  r.rank_total_country_account_cnt,
  r.rank_total_country_sent_cnt
FROM
  union_acc_email_data u
LEFT JOIN
  rank_data r
ON
  u.country = r.country
WHERE
  r.rank_total_country_account_cnt <= 10
  OR r.rank_total_country_sent_cnt <= 10
ORDER BY
  U.date;
