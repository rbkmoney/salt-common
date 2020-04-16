{% for user in users %}
 {% if users[user].otp_key is defined %}
HOTP/T30/6	{{ user }}	-	{{ users[user].otp_key }}
 {% endif %}
{% endfor %}
