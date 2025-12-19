// Correct FiveM pattern: use exports for the pool!
function getPool() {
    return global.exports.ingenium.getPool();
}

class TransactionManager {
    static async transaction(queries, callback = null) {
        let connection = null;
        try {
            const pool = getPool();
            connection = await pool.getConnection();
            await connection.beginTransaction();
            const results = [];

            for (const item of queries) {
                let query = item.query || item;
                let parameters = item.parameters || item.params || [];
                if (parameters && typeof parameters === 'object' && !Array.isArray(parameters)) {
                    const paramValues = [];
                    query = query.replace(/@(\w+)/g, (match, paramName) => {
                        const value = parameters[`@${paramName}`] || parameters[paramName];
                        paramValues.push(value !== undefined ? value : null);
                        return '?';
                    });
                    parameters = paramValues;
                }
                const [result] = await connection.execute(query, parameters);
                results.push(result);
            }
            await connection.commit();
            console.log(`^2[SQL] Transaction completed successfully (${queries.length} queries)^7`);
            if (callback && typeof callback === 'function') callback(true, results);
            return { success: true, results };
        } catch (error) {
            console.error(`^1[SQL] Transaction error: ${error.message}^7`);
            if (connection) {
                try { await connection.rollback(); console.log('^3[SQL] Transaction rolled back^7'); }
                catch (rollbackError) { console.error(`^1[SQL] Rollback error: ${rollbackError.message}^7`); }
            }
            if (callback && typeof callback === 'function') callback(false, []);
            return { success: false, results: [] };
        } finally {
            if (connection) connection.release();
        }
    }

    static async batch(queries, callback = null) {
        try {
            const pool = getPool();
            const results = [];
            for (const item of queries) {
                try {
                    let query = item.query || item;
                    let parameters = item.parameters || item.params || [];
                    if (parameters && typeof parameters === 'object' && !Array.isArray(parameters)) {
                        const paramValues = [];
                        query = query.replace(/@(\w+)/g, (match, paramName) => {
                            const value = parameters[`@${paramName}`] || parameters[paramName];
                            paramValues.push(value !== undefined ? value : null);
                            return '?';
                        });
                        parameters = paramValues;
                    }
                    const result = await pool.execute(query, parameters);
                    results.push({ success: true, result });
                } catch (error) {
                    console.error(`^3[SQL] Batch query error (continuing): ${error.message}^7`);
                    results.push({ success: false, error: error.message });
                }
            }
            const successCount = results.filter(r => r.success).length;
            console.log(`^2[SQL] Batch completed: ${successCount}/${queries.length} queries succeeded^7`);
            if (callback && typeof callback === 'function') callback(results);
            return results;
        } catch (error) {
            console.error(`^1[SQL] Batch error: ${error.message}^7`);
            if (callback && typeof callback === 'function') callback([]);
            return [];
        }
    }
}

global.exports('transaction', (queries, cb) => TransactionManager.transaction(queries, cb));
global.exports('batch', (queries, cb) => TransactionManager.batch(queries, cb));