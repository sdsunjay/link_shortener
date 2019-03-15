//Source: https://stackoverflow.com/questions/5717093/check-if-a-javascript-string-is-a-url
function isValidURL(string) {
  var res = string.match(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g);
  if (res == null)
    return false;
  else
    return true;
};

// The validator variable is a JSON Object
// The selector variable is a jQuery Object
window.ClientSideValidations.validators.local[':original_url'] = function(element, options) {
  // Your validator code goes in here
  if (isValidURL(element.val())) {
    // When the value fails to pass validation you need to return the error message.
    // It can be derived from validator.message
    return options.message;
  }
}
