// This source code is free for use in the public domain.
// NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
// http://code.google.com/p/json-sans-eval/
/**
 * Parses a string of well-formed JSON text.
 *
 * If the input is not well-formed, then behavior is undefined, but it is
 * deterministic and is guaranteed not to modify any object other than its
 * return value.
 *
 * This does not use `eval` so is less likely to have obscure security bugs than
 * json2.js.
 * It is optimized for speed, so is much faster than json_parse.js.
 *
 * This library should be used whenever security is a concern (when JSON may
 * come from an untrusted source), speed is a concern, and erroring on malformed
 * JSON is *not* a concern.
 *
 *                      Pros                   Cons
 *                    +-----------------------+-----------------------+
 * json_sans_eval.js  | Fast, secure          | Not validating        |
 *                    +-----------------------+-----------------------+
 * json_parse.js      | Validating, secure    | Slow                  |
 *                    +-----------------------+-----------------------+
 * json2.js           | Fast, some validation | Potentially insecure  |
 *                    +-----------------------+-----------------------+
 *
 * json2.js is very fast, but potentially insecure since it calls `eval` to
 * parse JSON data, so an attacker might be able to supply strange JS that
 * looks like JSON, but that executes arbitrary javascript.
 * If you do have to use json2.js with untrusted data, make sure you keep
 * your version of json2.js up to date so that you get patches as they're
 * released.
 *
 * @param {string} json per RFC 4627
 * @param {function (this:Object, string, *):*} opt_reviver optional function
 *     that reworks JSON objects post-parse per Chapter 15.12 of EcmaScript3.1.
 *     If supplied, the function is called with a string key, and a value.
 *     The value is the property of 'this'.  The reviver should return
 *     the value to use in its place.  So if dates were serialized as
 *     {@code { "type": "Date", "time": 1234 }}, then a reviver might look like
 *     {@code
 *     function (key, value) {
 *       if (value && typeof value === 'object' && 'Date' === value.type) {
 *         return new Date(value.time);
 *       } else {
 *         return value;
 *       }
 *     }}.
 *     If the reviver returns {@code undefined} then the property named by key
 *     will be deleted from its container.
 *     {@code this} is bound to the object containing the specified property.
 * @return {Object|Array}
 * @author Mike Samuel <mikesamuel@gmail.com>
 */
var jsonParse=function(){function o(e,t,n){return t?s[t]:String.fromCharCode(parseInt(n,16))}var e="(?:-?\\b(?:0|[1-9][0-9]*)(?:\\.[0-9]+)?(?:[eE][+-]?[0-9]+)?\\b)",t='(?:[^\\0-\\x08\\x0a-\\x1f"\\\\]|\\\\(?:["/\\\\bfnrt]|u[0-9A-Fa-f]{4}))',n='(?:"'+t+'*")',r=new RegExp("(?:false|true|null|[\\{\\}\\[\\]]|"+e+"|"+n+")","g"),i=new RegExp("\\\\(?:([^u])|u(.{4}))","g"),s={'"':'"',"/":"/","\\":"\\",b:"\b",f:"\f",n:"\n",r:"\r",t:"	"},u=new String(""),a="\\",f={"{":Object,"[":Array},l=Object.hasOwnProperty;return function(e,t){var n=e.match(r),s,f=n[0],c=!1;"{"===f?s={}:"["===f?s=[]:(s=[],c=!0);var h,p=[s];for(var d=1-c,v=n.length;d<v;++d){f=n[d];var m;switch(f.charCodeAt(0)){default:m=p[0],m[h||m.length]=+f,h=void 0;break;case 34:f=f.substring(1,f.length-1),f.indexOf(a)!==-1&&(f=f.replace(i,o)),m=p[0];if(!h){if(!(m instanceof Array)){h=f||u;break}h=m.length}m[h]=f,h=void 0;break;case 91:m=p[0],p.unshift(m[h||m.length]=[]),h=void 0;break;case 93:p.shift();break;case 102:m=p[0],m[h||m.length]=!1,h=void 0;break;case 110:m=p[0],m[h||m.length]=null,h=void 0;break;case 116:m=p[0],m[h||m.length]=!0,h=void 0;break;case 123:m=p[0],p.unshift(m[h||m.length]={}),h=void 0;break;case 125:p.shift()}}if(c){if(p.length!==1)throw new Error;s=s[0]}else if(p.length)throw new Error;if(t){var g=function(e,n){var r=e[n];if(r&&typeof r=="object"){var i=null;for(var s in r)if(l.call(r,s)&&r!==e){var o=g(r,s);o!==void 0?r[s]=o:(i||(i=[]),i.push(s))}if(i)for(var u=i.length;--u>=0;)delete r[i[u]]}return t.call(e,n,r)};s=g({"":s},"")}return s}}();