{% for user in users|selectattr("otp_key") recursive %}
HOTP/T30/6	{{ user }}	-	{{ user.otp_key }}
{% endfor %}
