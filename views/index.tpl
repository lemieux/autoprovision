<!DOCTYPE html>
<html lang="en">
  <head>
	<meta charset="utf-8">
	<title>Provisioning</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Le styles -->
	<link href="/static/bootstrap.min.css" rel="stylesheet">

	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
  </head>

  <body>

	<div class="container">
		<div class="row">
			<div class="span12">
				<h1>Nouveaux appareils à configurer <small> <a href="/refresh">Actualiser</a></small></h1>
				<table class="table">
					<thead>
						<tr>
							<th>Adresse IP</th>
							<th>Adresse MAC</th>
							<th>Extension</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						%for i,entry in enumerate(new_phones):
							<tr>
								<td>
									{{entry[0]}}
									<input type="hidden" value="{{entry[0]}}" id="createIp{{i}}">
								</td>
								<td>
									{{entry[1]}}
									<input type="hidden" value="{{entry[1]}}" id="createMac{{i}}">
								</td>
								<td><input type="text" value="" class="span1" id="createExtension{{i}}"></td>
								<td><button type="button" class="btn createButton" id="create{{i}}">Ajouter</button></td>
							</tr> 
						%end
					</tbody>
				</table>
				<h1>Appareils configurés</h1>
				<table class="table">
					<thead>
						<tr>
							<th>Adresse IP</th>
							<th>Adresse MAC</th>
							<th>Extension</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						%for i,entry in enumerate(configured_phones):
							<tr>
								<td>
									{{entry[0]}}
									<input type="hidden" value="{{entry[0]}}" id="modifyIp{{i}}">
								</td>
								<td>
									{{entry[1]}}
									<input type="hidden" value="{{entry[1]}}" id="modifyMac{{i}}">
								</td>
								<td><input type="text" value="" class="span1" id="modifyExtension{{i}}"></td>
								<td><button type="button" class="btn modifyButton" id="modify{{i}}">Modifier</button></td>
							</tr> 
						%end
					</tbody>
				</table>
			</div>
		</div>
	</div> 
	<script src="/static/jquery.min.js"></script>
	<script>
		$(function(){
			$('.createButton').on('click',function(e){
				var $target = $(e.target);
				var id = $target.attr('id').replace('create','');
				var extension = $('#createExtension'+id).val();
				var ip = $('#createIp'+id).val();
				var mac = $('#createMac'+id).val();
				if(extension !== ''){
					$.post('/create',{
						'ip' : ip,
						'mac' : mac,
						'extension' : extension
					}, function(data){
						window.location = '/';
					});
				}
				else{
					alert('Une extension est nécessaire.');
				}
			});
			$('.modifyButton').on('click',function(e){
				var $target = $(e.target);
				var id = $target.attr('id').replace('modify','');
				var extension = $('#modifyExtension'+id).val();
				var ip = $('#modifyIp'+id).val();
				var mac = $('#modifyMac'+id).val();
				if(extension !== ''){
					$.post('/modify',{
						'ip' : ip,
						'mac' : mac,
						'extension' : extension
					}, function(data){
						window.location = '/';
					});
				}
				else{
					alert('Une extension est nécessaire.');
				}
			});
		});
	</script>
  </body>
</html>
