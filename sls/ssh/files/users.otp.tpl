{% for user in users recursive %}
 {% if user.otp_key %}
HOTP/T30/6	{{ user }}	-	{{ user.otp_key }}
 {% endif %}
{% endfor %}
