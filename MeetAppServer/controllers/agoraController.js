Object.defineProperty(exports, "__esModule", { value: true });
exports.Agora = void 0;
const { RtcTokenBuilder, RtcRole } = require("agora-access-token");
var dotenv = require("dotenv");
dotenv.config();
// Rtc Examples
var appID = process.env.APP_ID;
var appCertificate = process.env.APP_CERTIFICATE;
var role = RtcRole.PUBLISHER;
var Agora = /** @class */ (function () {
    function Agora() {
    }
    Agora.generateToken = function (channelName) {
        const tokenA = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, 0, role);
        return tokenA;
    };
    return Agora;
}());
exports.Agora = Agora;