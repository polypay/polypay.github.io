---
layout: default
title: Classifieds
permalink: /classifieds/
description: Classified listings of Polypay sheep that are available for sale and for producers looking to buy Polypay sheep
max_months: 2
---

<div class="classifieds">
	<h2>Classifieds</h2>

{% assign month_secs = page.max_months | times: 31 | times: 60 | times: 60 | times: 24 %}
{% assign stale_ad_date = site.time | date: '%s' | minus: month_secs | date: '%s' %}

	<p>Classifieds ads for active members of the APSA advertising animals for sale or that they are in search of are free and will be placed for 60 days, after which they will be removed and can be resubmitted. To submit an ad, please complete the <a href="https://docs.google.com/forms/d/e/1FAIpQLSdIHiFJ4aIFTvj7loe9iwGuvALP3WLMOd27l9601dxztt6sVw/viewform?usp=sf_link" target="_blank">classifieds submission form</a>.</p>


	{% assign for_sale = site.classifieds | where:"classified", "for_sale" %}
	{% capture any_current_for_sale %}
	{%- include count_current_ads.html ads=for_sale -%}
	{% endcapture %}


	{% assign any_current_for_sale = any_current_for_sale | strip_newlines %}

	{% if for_sale.size > 0 and any_current_for_sale == "true" %}
		<div class="for-sale">
			<h3>For Sale</h3>
			{% include display_ad.html ads=for_sale %}
		</div>
	{% endif %}


	{% assign wanted = site.classifieds | where:"classified", "wanted" %}
	{% capture any_current_wanted %}
	{%- include count_current_ads.html ads=wanted -%}
	{% endcapture %}
	{% assign any_current_wanted = any_current_wanted | strip_newlines %}

	{% if wanted.size > 0 and any_current_wanted == "true" %}
		<div class="wanted">
			<h3>Wanted to Buy</h3>
			{% include display_ad.html ads=wanted %}
		</div>
	{% endif %}
</div>
