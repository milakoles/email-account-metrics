
# Student Metrics View – Module Test Project

This project contains a structured SQL view used for analyzing user account activity and email engagement across different dimensions. The goal of this analysis is to compare country-level behavior, identify key markets, and segment users based on account verification, subscription status, and email interaction metrics.

## 📌 View: `Students.v_kolesnyk_metrics`

### 📊 What it does:

The view aggregates and combines data from multiple sources to present a unified report of account and email metrics per date and per country. It filters for the top 10 countries based on the number of accounts created or emails sent.

### 🔍 Key Components:

- **Account Metrics (`account_data`)**:
  - Counts distinct accounts.
  - Segments by date, country, send interval, account verification, and subscription status.

- **Email Metrics (`email_data`)**:
  - Tracks the number of emails sent, opened, and clicked.
  - Segments by date and country.

- **Union (`union_acc_email_data`)**:
  - Combines account and email data into a single structure.

- **Country Ranking (`rank_data`)**:
  - Calculates total account and email counts per country.
  - Assigns ranks to countries by accounts and by emails.

- **Final Selection**:
  - Joins metric and rank data.
  - Filters for the top 10 countries by accounts or emails.
  - Orders results by date.

### 🗂 Output Fields:

- `date`, `country`, `send_interval`, `is_verified`, `is_unsubscribed`
- `account_cnt`, `sent_msg`, `open_msg`, `visit_msg`
- `total_country_account_cnt`, `total_country_sent_cnt`
- `rank_total_country_account_cnt`, `rank_total_country_sent_cnt`

## 📎 Usage Context:

This SQL view was developed as part of a module test for a data analytics training. It supports performance tracking, user behavior insights, and high-level engagement analysis that can feed into BI tools or dashboards.
