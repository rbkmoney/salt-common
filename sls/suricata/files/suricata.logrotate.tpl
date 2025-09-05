/var/log/suricata/*.log /var/log/suricata/*.json {
        rotate 3
        missingok
        create
        sharedscripts
	su {{ user }} {{ group }}
        postrotate
	        {% for name in instances %}
		{% if grains.os == "Gentoo" %}
                /etc/init.d/suricata.{{ name }} relog
		{% else %}
		kill -HUP $(cat /run/suricata/suricata-{{ name }}.pid)
		{% endif %}
		{% endfor %}
        endscript
}
