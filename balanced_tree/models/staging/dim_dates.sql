{{
    config(
        materialized='table'
    )
}}

SELECT
	datum as Date,
	extract(year from datum) AS Year,
	extract(month from datum) AS Month,
	-- Localized month name
	to_char(datum, 'TMMonth') AS month_name,
	extract(day from datum) AS day,
	extract(doy from datum) AS day_of_year,
	-- Localized weekday
	to_char(datum, 'TMDay') AS weekday_name,
	-- ISO calendar week
	extract(week from datum) AS calendar_week,
	to_char(datum, 'dd. mm. yyyy') AS formatted_date,
	'Q' || to_char(datum, 'Q') AS quartal,
	to_char(datum, 'yyyy/"Q"Q') AS year_quartal,
	to_char(datum, 'yyyy/mm') AS year_month,
	-- ISO calendar year and week
	to_char(datum, 'iyyy/IW') AS year_calendar_week,
	-- Weekend
	CASE WHEN extract(isodow from datum) in (6, 7) THEN 'Weekend' ELSE 'Weekday' END AS weekend,
	-- Fixed holidays 
        -- for America
        CASE WHEN to_char(datum, 'MMDD') IN ('0101', '0704', '1225', '1226')
		THEN 'Holiday' ELSE 'No holiday' END
		AS american_holiday,
        -- for Austria
	CASE WHEN to_char(datum, 'MMDD') IN 
		('0101', '0106', '0501', '0815', '1101', '1208', '1225', '1226') 
		THEN 'Holiday' ELSE 'No holiday' END 
		AS austrian_holiday,
        -- for Canada
        CASE WHEN to_char(datum, 'MMDD') IN ('0101', '0701', '1225', '1226')
		THEN 'Holiday' ELSE 'No holiday' END 
		AS canadian_holiday,
	-- Some periods of the year, adjust for your organisation and country
	CASE WHEN to_char(datum, 'MMDD') BETWEEN '0701' AND '0831' THEN 'Summer break'
	     WHEN to_char(datum, 'MMDD') BETWEEN '1115' AND '1225' THEN 'Christmas season'
	     WHEN to_char(datum, 'MMDD') > '1225' OR to_char(datum, 'MMDD') <= '0106' THEN 'Winter break'
		ELSE 'Normal' END
		AS period,
	-- ISO start and end of the week of this date
	datum + (1 - extract(isodow from datum))::integer AS calendar_week_start,
	datum + (7 - extract(isodow from datum))::integer AS calander_week_end,
	-- Start and end of the month of this date
	datum + (1 - extract(day from datum))::integer AS month_start,
	(datum + (1 - extract(day from datum))::integer + '1 month'::interval)::date - '1 day'::interval AS month_end
FROM (
	-- There are 3 leap years in this range, so calculate 365 * 10 + 3 records
	SELECT '2021-01-01'::DATE + sequence.day AS datum
	FROM generate_series(0,89) AS sequence(day)
	GROUP BY sequence.day
     ) DQ
order by 1