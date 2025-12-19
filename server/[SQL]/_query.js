// Correct FiveM pattern: use exports for the pool!
function getPool() {
    return global.exports.ingenium.getPool();
}

class QueryExecutor {
    static convertNamedParameters(query, params) {
        if (!params || typeof params !== 'object' || Array.isArray(params)) {
            return { query, parameters: params || [] };
        }
        const paramNames = [];
        const paramValues = [];
        const convertedQuery = query.replace(/@(\w+)/g, (match, paramName) => {
            const value = params[`@${paramName}`] || params[paramName];
            paramValues.push(value !== undefined ? value : null);
            paramNames.push(paramName);
            return '?';
        });
        return { query: convertedQuery, parameters: paramValues };
    }

    static async query(queryString, parameters = [], callback = null) {
        try {
            const pool = getPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            const data = Array.isArray(results) ? results : [];
            if (callback && typeof callback === 'function') callback(data);
            return data;
        } catch (error) {
            console.error(`^1[SQL] Query error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback([]);
            return [];
        }
    }

    static async fetchSingle(queryString, parameters = [], callback = null) {
        try {
            const pool = getPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            const data = Array.isArray(results) && results.length > 0 ? results[0] : null;
            if (callback && typeof callback === 'function') callback(data);
            return data;
        } catch (error) {
            console.error(`^1[SQL] FetchSingle error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback(null);
            return null;
        }
    }

    static async fetchScalar(queryString, parameters = [], callback = null) {
        try {
            const pool = getPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            let data = null;
            if (Array.isArray(results) && results.length > 0) {
                const firstRow = results[0];
                const firstKey = Object.keys(firstRow)[0];
                data = firstRow[firstKey];
            }
            if (callback && typeof callback === 'function') callback(data);
            return data;
        } catch (error) {
            console.error(`^1[SQL] FetchScalar error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback(null);
            return null;
        }
    }

    static async insert(queryString, parameters = [], callback = null) {
        try {
            const pool = getPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            const insertId = results.insertId || 0;
            if (callback && typeof callback === 'function') callback(insertId);
            return insertId;
        } catch (error) {
            console.error(`^1[SQL] Insert error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback(0);
            return 0;
        }
    }

    static async update(queryString, parameters = [], callback = null) {
        try {
            const pool = getPool();
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            const affectedRows = results.affectedRows || 0;
            if (callback && typeof callback === 'function') callback(affectedRows);
            return affectedRows;
        } catch (error) {
            console.error(`^1[SQL] Update error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback(0);
            return 0;
        }
    }

    static prepareQuery(queryString) {
        const queryId = Math.random().toString(36).substring(7);
        global.preparedQueries = global.preparedQueries || {};
        global.preparedQueries[queryId] = queryString;
        return queryId;
    }

    static async executePrepared(queryId, parameters = [], callback = null) {
        try {
            if (!global.preparedQueries || !global.preparedQueries[queryId]) {
                throw new Error(`Prepared query ${queryId} not found`);
            }
            const pool = getPool();
            const queryString = global.preparedQueries[queryId];
            const { query, parameters: params } = this.convertNamedParameters(queryString, parameters);
            const results = await pool.execute(query, params);
            const affectedRows = results.affectedRows || 0;
            if (callback && typeof callback === 'function') callback(affectedRows);
            return affectedRows;
        } catch (error) {
            console.error(`^1[SQL] ExecutePrepared error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback(0);
            return 0;
        }
    }
}

global.exports('query', (query, params, cb) => QueryExecutor.query(query, params, cb));
global.exports('fetchSingle', (query, params, cb) => QueryExecutor.fetchSingle(query, params, cb));
global.exports('fetchScalar', (query, params, cb) => QueryExecutor.fetchScalar(query, params, cb));
global.exports('insert', (query, params, cb) => QueryExecutor.insert(query, params, cb));
global.exports('update', (query, params, cb) => QueryExecutor.update(query, params, cb));
global.exports('prepareQuery', (query) => QueryExecutor.prepareQuery(query));
global.exports('executePrepared', (queryId, params, cb) => QueryExecutor.executePrepared(queryId, params, cb));