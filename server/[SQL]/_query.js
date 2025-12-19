/**
 * Query Execution Engine
 * Handles query execution with parameter conversion and result formatting
 */

const getPool = () => global.exports.ingenium.getPool();

class QueryExecutor {
    /**
     * Convert named parameters (@param) to positional (?)
     * Maintains compatibility with legacy mysql-async syntax
     */
    static convertNamedParameters(query, params) {
        if (!params || typeof params !== 'object' || Array.isArray(params)) {
            // Already using positional parameters
            return { query, parameters: params || [] };
        }

        // Named parameters detected
        const paramNames = [];
        const paramValues = [];
        
        // Replace @paramName with ? and collect values
        const convertedQuery = query.replace(/@(\w+)/g, (match, paramName) => {
            const value = params[`@${paramName}`] || params[paramName];
            paramValues.push(value !== undefined ? value : null);
            paramNames.push(paramName);
            return '?';
        });

        return { query: convertedQuery, parameters: paramValues };
    }

    /**
     * Execute a SELECT query that returns multiple rows
     */
    static async query(queryString, parameters = [], callback = null) {
        try {
            const pool = new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            // Return array of results
            const data = Array.isArray(results) ? results : [];
            
            if (callback && typeof callback === 'function') {
                callback(data);
            }
            
            return data;
        } catch (error) {
            console.error(`^1[SQL] Query error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback([]);
            }
            
            return [];
        }
    }

    /**
     * Execute a SELECT query that returns a single row
     */
    static async fetchSingle(queryString, parameters = [], callback = null) {
        try {
            const pool =new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            // Return first row or null
            const data = Array.isArray(results) && results.length > 0 ? results[0] : null;
            
            if (callback && typeof callback === 'function') {
                callback(data);
            }
            
            return data;
        } catch (error) {
            console.error(`^1[SQL] FetchSingle error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback(null);
            }
            
            return null;
        }
    }

    /**
     * Execute a SELECT query that returns a single value (scalar)
     */
    static async fetchScalar(queryString, parameters = [], callback = null) {
        try {
            const pool =new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            // Return first column of first row
            let data = null;
            if (Array.isArray(results) && results.length > 0) {
                const firstRow = results[0];
                const firstKey = Object.keys(firstRow)[0];
                data = firstRow[firstKey];
            }
            
            if (callback && typeof callback === 'function') {
                callback(data);
            }
            
            return data;
        } catch (error) {
            console.error(`^1[SQL] FetchScalar error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback(null);
            }
            
            return null;
        }
    }

    /**
     * Execute an INSERT query
     */
    static async insert(queryString, parameters = [], callback = null) {
        try {
            const pool =new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            // Return insertId
            const insertId = results.insertId || 0;
            
            if (callback && typeof callback === 'function') {
                callback(insertId);
            }
            
            return insertId;
        } catch (error) {
            console.error(`^1[SQL] Insert error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback(0);
            }
            
            return 0;
        }
    }

    /**
     * Execute an UPDATE or DELETE query
     */
    static async update(queryString, parameters = [], callback = null) {
        try {
            const pool =new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            // Return affectedRows
            const affectedRows = results.affectedRows || 0;
            
            if (callback && typeof callback === 'function') {
                callback(affectedRows);
            }
            
            return affectedRows;
        } catch (error) {
            console.error(`^1[SQL] Update error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback(0);
            }
            
            return 0;
        }
    }

    /**
     * Prepare a stored query (for use with MySQL.Async.store compatibility)
     */
    static prepareQuery(queryString) {
        // Generate a unique ID for this prepared query
        const queryId = Math.random().toString(36).substring(7);
        
        // Store the query string for later use
        global.preparedQueries = global.preparedQueries || {};
        global.preparedQueries[queryId] = queryString;
        
        return queryId;
    }

    /**
     * Execute a prepared query
     */
    static async executePrepared(queryId, parameters = [], callback = null) {
        try {
            if (!global.preparedQueries || !global.preparedQueries[queryId]) {
                throw new Error(`Prepared query ${queryId} not found`);
            }
            
            const queryString = global.preparedQueries[queryId];
            const pool =new ConnectionPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            
            const results = await pool.execute(query, params);
            
            const affectedRows = results.affectedRows || 0;
            
            if (callback && typeof callback === 'function') {
                callback(affectedRows);
            }
            
            return affectedRows;
        } catch (error) {
            console.error(`^1[SQL] ExecutePrepared error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback(0);
            }
            
            return 0;
        }
    }
}

// Export query execution functions
global.exports('query', (query, params, cb) => QueryExecutor.query(query, params, cb));
global.exports('fetchSingle', (query, params, cb) => QueryExecutor.fetchSingle(query, params, cb));
global.exports('fetchScalar', (query, params, cb) => QueryExecutor.fetchScalar(query, params, cb));
global.exports('insert', (query, params, cb) => QueryExecutor.insert(query, params, cb));
global.exports('update', (query, params, cb) => QueryExecutor.update(query, params, cb));
global.exports('prepareQuery', (query) => QueryExecutor.prepareQuery(query));
global.exports('executePrepared', (queryId, params, cb) => QueryExecutor.executePrepared(queryId, params, cb));
