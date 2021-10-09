Object.defineProperty(exports, "__esModule", { value: true });
exports.MemCache = void 0;
var MemCache = /** @class */ (function () {
    function MemCache() {
    }
    MemCache.hset = function (set, key, val) {
        if (!this.memCache[set]) {
            this.memCache[set] = {};
        }
        this.memCache[set][key] = val;
    };
    MemCache.hget = function (set, key) {
        var val = null;
        if (this.memCache[set] && this.memCache[set][key]) {
            val = this.memCache[set][key];
        }
        return val;
    };
    MemCache.hdel = function (set, key) {
        if (this.memCache[set] && this.memCache[set][key]) {
            delete this.memCache[set][key];
        }
    };
    MemCache.memCache = {};
    return MemCache;
}());
exports.MemCache = MemCache;