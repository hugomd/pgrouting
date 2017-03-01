/*PGR-GNU*****************************************************************

Copyright (c) 2017 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2017 Celia Virginia Vergara Castillo
mail: vicky_vergara@hotmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

********************************************************************PGR-GNU*/


-- one to one
CREATE OR REPLACE FUNCTION pgr_bdAstarCost(
    edges_sql TEXT,
    BIGINT,
    BIGINT,
    directed BOOLEAN DEFAULT true,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT a.start_vid, a.end_vid, a.agg_cost
    FROM _pgr_bdAstar(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], ARRAY[$3]::BIGINT[], $4, $5, $6, $7, true) AS a;
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;

-- one to many
CREATE OR REPLACE FUNCTION pgr_bdAstarCost(
    edges_sql TEXT,
    BIGINT,
    end_vids ANYARRAY,
    directed BOOLEAN,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT a.start_vid, a.end_vid, a.agg_cost
    FROM _pgr_bdAstar(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], $3::BIGINT[], $4, $5, $6, $7, true) AS a;
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;

-- many to one
CREATE OR REPLACE FUNCTION pgr_bdAstarCost(
    edges_sql TEXT,
    start_vids ANYARRAY,
    BIGINT,
    directed BOOLEAN,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT a.start_vid, a.end_vid, a.agg_cost
    FROM _pgr_bdAstar(_pgr_get_statement($1), $2::BIGINT[], ARRAY[$3]::BIGINT[], $4, $5, $6, $7, true) AS a;
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;

-- many to many
CREATE OR REPLACE FUNCTION pgr_bdAstarCost(
    edges_sql TEXT,
    start_vids ANYARRAY,
    end_vids ANYARRAY,
    directed BOOLEAN,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT a.start_vid, a.end_vid, a.agg_cost
    FROM _pgr_bdAstar(_pgr_get_statement($1), $2::BIGINT[], $3::BIGINT[], $4, $5, $6, $7, true) AS a;
$BODY$
LANGUAGE sql VOLATILE
COST 100
ROWS 1000;
