var versionUrl = '//cdnt.netcoresmartech.com/smartech_v3.0.js';
var allwedForV4 = [
    'demo2.netcoresmartech.com',
    'voolatech.com',
    'duluxmy.splashinteractive.sg',
    'uae.danubehome.com',
    'xyxxcrew.com',
    'vexere.com',
    'fidelitypensionmanagers.com',
    'en-ae.randbfashion.com',
    'ar-ae.randbfashion.com',
    'en-qa.randbfashion.com',
    'ar-qa.randbfashion.com',
    'www.celebrityschool.in',
    'www.in2nutrition.in',
    'www.registry.in',
    'www.getketch.com',
    'flexxzone.fcmb.com',
    'www.veromoda.in',
    'www.jackjones.in',
    'www.only.in',
    'www.selectedhomme.in',
    'www.bestsellerclothing.in',
    'mobilewebdev.ralali.xyz',
    'www.chumbak.com',
    'getmeds.ph',
    'oman.danubehome.com',
    'bahrain.danubehome.com',
    'kuwait.danubehome.com',
    'ntest.jaypore.com',
    'www.gautamrose.net',
    'www.ritukumar.com',
    'www.labelritukumar.com',
    'www.coronationinsurance.com.ng',
    'dev.ralali.xyz',
    'ri.ritukumar.com',
    'www.aarke.in',
    'landingpage.voolatech.com',
    'in.danubehome.com',
    'tuoitre.vn',
    'cuoituan.tuoitre.vn',
    'shive.life',
    'zm.texilaacademy.com',
    'in2uat.express.shoptimize.in',
    'www.bata.in',
    'www.bramhacorp.in',
    'lifepal.co.id',
    'www.prudential.com.vn',
    'ecommerce-uat.prudential.com.vn',
    'gate.prudential.com.vn',
    'dulux.com.my',
    'duluxprofessionalsg.karmatechstaging.com',
    'matchbook-uat.prudential.com.vn',
    'sumadhuragroup.com',
    'dev-ui.udchalo.com',
    'portal-uat.prudential.com.vn'
];
var currentDomain = window.location.hostname;
if (allwedForV4.includes(currentDomain)) {
    versionUrl = '//cdnt.netcoresmartech.com/smartech_v4.0.js';
}
(function (w, d, s, f, o, a, m) {
    w['SmartechObject'] = o;
    w[o] = w[o] || function (a, c, n) {
        (w[o].q = w[o].q || []).push(arguments);
    };
    var config = localStorage.getItem('__stconfig') || null;
    if (config) {
        var cnfg = JSON.parse(config),
            expd = new Date(cnfg.exd);
        if (expd > new Date()) {
            if (cnfg.ps === '0' || cnfg.js === '0') {
                console.log("Js blocked.");
                return;
            }
        } else {
            localStorage.removeItem('__stconfig');
        }
    }
    a = d.createElement(s);
    m = d.getElementsByTagName(s)[0];
    a.async = 1;
    a.src = f;
    a.id = 'smartech_v3';
    var smt = document.getElementById(a.id);
    if (!smt) {
        m.parentNode.insertBefore(a, m);
    }
})(window, document, 'script', versionUrl + '?ver=1.3', 'smartech');