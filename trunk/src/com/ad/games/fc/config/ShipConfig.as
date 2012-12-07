package com.ad.games.fc.config
{
	public class ShipConfig
	{
		public static const SHIPS:Object = {
			
			/*
			* Borodino class
			*/
			
			"Borodino": {
				"_class": "BB",
				"type": "Borodino",
				"nation": 2,
				"maxSpeed": 1.8,
				"maxAngleSpeed": 2,
				"acceleration": 0.05,
				"equipment": [
					{
						"_class": "Hull",
						"mapShape": {
							"_class": "MapShipHullShape",
							"shapeResource": "BorodinoClassHullMapShape",
							"scaleX": 0.5,
							"scaleY": 0.5
						},
						"equipment": [
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret12MapShape",
									"dX": 36,
									"scaleX": 1.5,
									"scaleY": 1.5												
								},
								"minAngle": -135,
								"maxAngle": 135,
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun12MapShape",
											"dX": 3.5,
											"dY": -1
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun12MapShape",
											"dX": 3.5,
											"dY": 1
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": 22,
									"dY": -8,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": -135,
								"maxAngle": 0,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},				
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": 22,
									"dY": 8,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": 0,
								"maxAngle": 135,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": 4,
									"dY": -10,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": -135,
								"maxAngle": -45,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": 4,
									"dY": 10,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": 45,
								"maxAngle": 135,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},				
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": -26,
									"dY": 8,
									"scaleX": 2,
									"scaleY": 2,
									"rotation": 180						
								},
								"minAngle": 45,
								"maxAngle": 180,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},				
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret6MapShape",
									"dX": -26,
									"dY": -8,
									"scaleX": 2,
									"scaleY": 2,
									"rotation": 180				
								},
								"minAngle": -180,
								"maxAngle": -45,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": -0.5
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun6MapShape",
											"scaleX": 0.75,
											"dX": 2,
											"dY": 0.5
										}
									}
								]
							},
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "BorodinoClassTurret12MapShape",
									"rotation": 180,
									"dX": -40,
									"scaleX": 1.5,
									"scaleY": 1.5											
								},
								"minAngle": 45,
								"maxAngle": -45,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun12MapShape",
											"dX": 3.5,
											"dY": -1
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "BorodinoClassGun12MapShape",
											"dX": 3.5,
											"dY": 1
										}
									}
								]
							},
							{
								"_class": "Structure",
								"mapShape": {
									"_class": "MapStructureShape",
									"shapeResource": "BorodinoClassStructureMapShape",
									"dX": -4
								},
								"equipment": [
//									{
//										"_class": "BridgeStructure",
//										"mapShape": {
//											"_class": "MapTubeShape",
//											"shapeResource": "ShipTowerMapShape",
//											"scaleX": 1.5,
//											"scaleY": 1.5,
//											"dX": 26
//										}
//									},
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "BorodinoClassTubeMapShape",
											"scaleX": 2,
											"scaleY": 2,
											"dX": 16
										}
									},
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "BorodinoClassTubeMapShape",
											"scaleX": 2,
											"scaleY": 2
										}
									}
//									,
//									{
//										"_class": "BridgeStructure",
//										"mapShape": {
//											"_class": "MapTubeShape",
//											"shapeResource": "ShipTowerMapShape",
//											"scaleX": 1.5,
//											"scaleY": 1.5,
//											"dX": -22
//										}
//									}
								]
							}
						]
					}
				]
			},
			
			/*
			 * Scharnhorst class
			 */
			
			"Scharnhorst": {
				"_class": "BB",
				"type": "Scharnhorst",
				"nation": 1,
				"maxSpeed": 2.5,
				"maxAngleSpeed": 2,
				"acceleration": 0.1,
				"equipment": [
					{
						"_class": "Hull",
						"mapShape": {
							"_class": "MapShipHullShape",
							"shapeResource": "ScharnhorstClassHullMapShape",
							"scaleX": 0.5,
							"scaleY": 0.5
						},
						"equipment": [
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassTurret8MapShape",
									"dX": 40,
									"scaleX": 1.5,
									"scaleY": 1.5												
								},
								"minAngle": -135,
								"maxAngle": 135,
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 5.5,
											"dY": -1
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 5.5,
											"dY": 1
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassTurret8MapShape",
									"dX": -43,
									"scaleX": 1.5,
									"scaleY": 1.5,
									"rotation": 180
								},
								"minAngle": 45,
								"maxAngle": -45,
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 5.5,
											"dY": -1
										}
									},
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 5.5,
											"dY": 1
										}
									}
								]
							},							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 16,
									"dY": -10.5,
									"scaleX": 1.5,
									"scaleY": 1.5						
								},
								"minAngle": -135,
								"maxAngle": 0,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": -0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 16,
									"dY": 10.5,
									"scaleX": 1.5,
									"scaleY": 1.5						
								},
								"minAngle": 0,
								"maxAngle": 135,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": 0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 4,
									"dY": 11,
									"scaleX": 1.5,
									"scaleY": 1.5,
									"rotation": 90
								},
								"minAngle": 0,
								"maxAngle": 135,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": 0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 4,
									"dY": -11,
									"scaleX": 1.5,
									"scaleY": 1.5,
									"rotation": -90
								},
								"minAngle": -135,
								"maxAngle": 0,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": -0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": -9,
									"dY": 10.5,
									"scaleX": 1.5,
									"scaleY": 1.5,
									"rotation": 180
								},
								"minAngle": 45,
								"maxAngle": 180,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": -0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": -9,
									"dY": -10.5,
									"scaleX": 1.5,
									"scaleY": 1.5,
									"rotation": 180
								},
								"minAngle": -180,
								"maxAngle": -45,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": 0.5
										}
									}
								]
							},							
							{
								"_class": "Structure",
								"mapShape": {
									"_class": "MapEquipmentShape",
									"shapeResource": "ScharnhorstClassBatteryDeckMapShape",
									"dX": 4
								}
							},
							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 12,
									"dY": -10.5,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": -135,
								"maxAngle": 0,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": -0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": 12,
									"dY": 10.5,
									"scaleX": 2,
									"scaleY": 2						
								},
								"minAngle": 0,
								"maxAngle": 135,						
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": 0.5
										}
									}
								]
							},							
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": -5,
									"dY": -10.5,
									"scaleX": 2,
									"scaleY": 2,
									"rotation": -180					
								},
								"minAngle": -180,
								"maxAngle": -45,
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": 0.5
										}
									}
								]
							},
							{
								"_class": "Turret",
								"mapShape": {
									"_class": "MapTurretShape",
									"shapeResource": "ScharnhorstClassCasemate8MapShape",
									"dX": -5,
									"dY": 10.5,
									"scaleX": 2,
									"scaleY": 2,
									"rotation": 180					
								},
								"minAngle": 45,
								"maxAngle": 180,							
								"equipment": [
									{
										"_class": "Gun",
										"mapShape": {
											"_class": "MapGunShape",
											"shapeResource": "ScharnhorstClassGun8MapShape",
											"dX": 3.5,
											"dY": -0.5
										}
									}
								]
							},							
							{
								"_class": "Structure",
								"mapShape": {
									"_class": "MapStructureShape",
									"shapeResource": "ScharnhorstClassDeckMapShape",
									"dX": -2
								},
								"equipment": [
									{
										"_class": "BridgeStructure",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ScharnhorstClassFrontBridgeMapShape",
											"scaleX": 1.5,
											"scaleY": 1.5,
											"dX": 28
										}
									},
									{
										"_class": "BridgeStructure",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ShipTowerMapShape",
											"scaleX": 1.5,
											"scaleY": 1.5,
											"dX": 26
										}
									},									
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ScharnhorstClassFrontTubeMapShape",
											"scaleX": 1.25,
											"scaleY": 1.25,
											"dX": 16
										}
									},
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ScharnhorstClassFrontTubeMapShape",
											"scaleX": 1.25,
											"scaleY": 1.25,
											"dX": 8
										}
									},
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ScharnhorstClassFrontTubeMapShape",
											"scaleX": 1.25,
											"scaleY": 1.25,
											"dX": 0
										}
									},
									{
										"_class": "Tube",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ScharnhorstClassFrontTubeMapShape",
											"scaleX": 1.25,
											"scaleY": 1.25,
											"dX": -8
										}
									}
									,
									{
										"_class": "BridgeStructure",
										"mapShape": {
											"_class": "MapTubeShape",
											"shapeResource": "ShipTowerMapShape",
											"scaleX": 1.5,
											"scaleY": 1.5,
											"dX": -28
										}
									}
								]
							}
						]
					}
				]
			}			
		};
	}
}