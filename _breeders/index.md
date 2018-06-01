---
layout: default
title: Breeders
permalink: /breeders/
description: Directory of Polypay sheep breeders and growers near you with information on how to get ahold of them by mail, phone, email, and their websites
---

<div class="breeder-directory container">

	<h2>Breeder Directory</h2>

	<p class="disclaimer">This membership directory includes active members as of June 2018. A <a href="/assets/pdfs/directory-2018-06-01.pdf" target="_blank">PDF version of the directory</a> is also available. The <i class="fas fa-link fa-sm"></i> icon links to the breeder's website and <i class="fas fa-envelope fa-sm"></i> to their email address.</p>

	<div class="row">
		<div class="col-md-4">
			{% assign unique_states = site.breeders | map: 'state' | compact | sort | uniq %}

			{% for state in unique_states %}
				<a href="#{{state}}" class="state-links">{{ site.data.states_map[state] }}</a>
			{% endfor %}

			{% for state in unique_states %}
				<div class="state-chunk">

					<h3 id="{{state}}">{{ site.data.states_map[state] }}</h3>
					{% assign state_breeder = site.breeders | where: "state", state %}

					{% for breeder in state_breeder %}
						{% include membership_entry.html member=breeder %}
					{% endfor %}

					<p class="back-to-top"><a href="#">back to top</a></p>
				</div>
			{% endfor %}

		</div>
		<div class="col-md-8 map-column">

  		<div class="map" style="height: 500px;"></div>


			<script src="/assets/js/membership_map.js"></script>
			<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js" async defer></script>
			<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCQtYXTjORR_cR8rKRRCzkaGn88CJHQY9o&callback=initMap" async defer></script>

			<h3>Board of Directors</h3>
			<div class="row">
				<div class="col-md-6">
						{% assign prez = site.breeders | where:"title","President" | compact | first %}
						{% include membership_entry.html member=prez role=true %}

						{% assign vp = site.breeders | where:"title","Vice-President" | compact | first %}
						{% include membership_entry.html member=vp role=true  %}

						{% assign sec = site.breeders | where:"title","Secretary" | compact | first %}
						{% include membership_entry.html member=sec role=true  %}

						{% assign treas = site.breeders | where:"title","Treasurer" | compact | first %}
						{% include membership_entry.html member=treas role=true  %}
				</div>

				<div class="col-md-6">
						{% assign directors = site.breeders | where:"title","director" %}
						{% for director in directors %}
							{% include membership_entry.html member=director %}
						{% endfor %}
				</div>
			</div>

		</div>
	</div>
</div>
