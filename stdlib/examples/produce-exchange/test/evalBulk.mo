let T = (import "../serverTypes.mo");
let A = (import "../serverActor.mo");
let Result = (import "../../../result.mo");
let Option = (import "../../../option.mo");

func printEntityCount(entname:Text, count:Nat) {
  print ("- " # entname # " count: ");
  printInt count;
  print "\n";
};

func printLabeledCost(lab:Text, cost:Nat) {
  print ("- " # lab # " cost: ");
  printInt cost;
  print "\n";
};

actor class Test() = this {
  public func go() {
    ignore(async
    {
      let s = A.Server();

      print "\nExchange setup: Begin...\n====================================\n";

      let pka = "beef";
      let pkb = "dead";
      let pkc = "4242";
      let pkd = "1234";
      let pke = "f00d";

      let bulkResp = s.evalBulkArray(
        [
          #add([
                 #truckType { id=0; short_name="tta"; description=""; capacity=10; isFridge=false; isFreezer=false },
                 #truckType { id=1; short_name="ttb"; description=""; capacity=20; isFridge=false; isFreezer=false },
                 #truckType { id=2; short_name="ttc"; description=""; capacity=30; isFridge=true; isFreezer=false },
                 #truckType { id=3; short_name="ttd"; description=""; capacity=40; isFridge=true; isFreezer=false },
                 #truckType { id=4; short_name="tte"; description=""; capacity=50; isFridge=true; isFreezer=true },

                 #region { id=0; short_name="rega"; description=""; },
                 #region { id=1; short_name="regb"; description=""; },
                 #region { id=2; short_name="regc"; description=""; },
                 #region { id=3; short_name="regd"; description=""; },

                 #produce { id=0; short_name="avocado"; description=""; grade=1},
                 #produce { id=1; short_name="apple"; description=""; grade=1},
                 #produce { id=2; short_name="banana"; description=""; grade=1},
                 #produce { id=3; short_name="grapefruit"; description=""; grade=1},

                 #user { user_name="a"; public_key=pka; description=""; region=0;
                                 isDeveloper=true; isProducer=true; isRetailer=true; isTransporter=true },
                 #user { user_name="b"; public_key=pkb; description=""; region=1;
                                 isDeveloper=true; isProducer=true; isRetailer=true; isTransporter=true },
                 #user { user_name="c"; public_key=pkc; description=""; region=2;
                                 isDeveloper=true; isProducer=true; isRetailer=true; isTransporter=true },
                 #user { user_name="d"; public_key=pkd; description=""; region=3;
                                 isDeveloper=true; isProducer=true; isRetailer=true; isTransporter=true },
                 #user { user_name="e"; public_key=pke; description=""; region=0;
                                 isDeveloper=true; isProducer=true; isRetailer=true; isTransporter=true },

                 #inventory { id=0; produce=0; producer=0; start_date=0; end_date=10; quantity=100; weight=100; ppu=2; comments=""},
                 #inventory { id=0; produce=1; producer=0; start_date=1; end_date=10; quantity=100; weight=100; ppu=2; comments=""},
                 #inventory { id=0; produce=2; producer=0; start_date=2; end_date=10; quantity=100; weight=100; ppu=2; comments=""},
                 #inventory { id=0; produce=3; producer=0; start_date=3; end_date=10; quantity=100; weight=100; ppu=2; comments=""},

                 #inventory { id=0; produce=0; producer=1; start_date=2; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=1; producer=1; start_date=0; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=2; producer=1; start_date=2; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=3; producer=1; start_date=0; end_date=10; quantity=100; weight=100; ppu=3; comments=""},

                 #inventory { id=0; produce=0; producer=2; start_date=0; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=1; producer=2; start_date=1; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=2; producer=2; start_date=2; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=3; producer=2; start_date=5; end_date=10; quantity=100; weight=100; ppu=3; comments=""},

                 #inventory { id=0; produce=0; producer=3; start_date=2; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=1; producer=3; start_date=1; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=2; producer=3; start_date=2; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=3; producer=3; start_date=1; end_date=10; quantity=100; weight=100; ppu=3; comments=""},

                 #inventory { id=0; produce=0; producer=4; start_date=6; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=1; producer=4; start_date=7; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=2; producer=4; start_date=8; end_date=10; quantity=100; weight=100; ppu=3; comments=""},
                 #inventory { id=0; produce=3; producer=4; start_date=9; end_date=10; quantity=100; weight=100; ppu=3; comments=""},

                 #route { id=0; transporter=0; truck_type=0; start_region=0; end_region=1; start_date=0; end_date=10; cost=100 },
                 #route { id=0; transporter=0; truck_type=0; start_region=0; end_region=2; start_date=1; end_date=10; cost=100 },
                 #route { id=0; transporter=0; truck_type=0; start_region=0; end_region=3; start_date=2; end_date=10; cost=100 },
                 #route { id=0; transporter=0; truck_type=0; start_region=0; end_region=4; start_date=3; end_date=10; cost=100 },

                 #route { id=0; transporter=1; truck_type=0; start_region=1; end_region=1; start_date=0; end_date=10; cost=100 },
                 #route { id=0; transporter=1; truck_type=0; start_region=1; end_region=2; start_date=1; end_date=10; cost=100 },
                 #route { id=0; transporter=1; truck_type=0; start_region=1; end_region=3; start_date=2; end_date=10; cost=100 },
                 #route { id=0; transporter=1; truck_type=0; start_region=1; end_region=4; start_date=3; end_date=10; cost=100 },

                 #route { id=0; transporter=2; truck_type=0; start_region=2; end_region=1; start_date=0; end_date=10; cost=100 },
                 #route { id=0; transporter=2; truck_type=0; start_region=2; end_region=2; start_date=1; end_date=10; cost=100 },
                 #route { id=0; transporter=2; truck_type=0; start_region=2; end_region=3; start_date=2; end_date=10; cost=100 },
                 #route { id=0; transporter=2; truck_type=0; start_region=2; end_region=4; start_date=3; end_date=10; cost=100 },

                 #route { id=0; transporter=3; truck_type=0; start_region=3; end_region=1; start_date=0; end_date=10; cost=100 },
                 #route { id=0; transporter=3; truck_type=0; start_region=3; end_region=2; start_date=1; end_date=10; cost=100 },
                 #route { id=0; transporter=3; truck_type=0; start_region=3; end_region=3; start_date=2; end_date=10; cost=100 },
                 #route { id=0; transporter=3; truck_type=0; start_region=3; end_region=4; start_date=3; end_date=10; cost=100 },

                 #route { id=0; transporter=4; truck_type=0; start_region=4; end_region=1; start_date=0; end_date=10; cost=100 },
                 #route { id=0; transporter=4; truck_type=0; start_region=4; end_region=2; start_date=1; end_date=10; cost=100 },
                 #route { id=0; transporter=4; truck_type=0; start_region=4; end_region=3; start_date=2; end_date=10; cost=100 },
                 #route { id=0; transporter=4; truck_type=0; start_region=4; end_region=4; start_date=3; end_date=10; cost=100 },

               ])
        ]
      );

      let uida = #ok 0;
      let uidb = #ok 1;
      let uidc = #ok 2;
      let uidd = #ok 3;
      let uide = #ok 4;

      await debugDumpAll(s);

      //////////////////////////////////////////////////////////////////

      print "\nRetailer queries\n====================================\n";

      // do some queries
      await retailerQueryAll(s, pka, ? Result.assertUnwrapAny<T.UserId>(uida));
      await retailerQueryAll(s, pkb, ? Result.assertUnwrapAny<T.UserId>(uidb));
      await retailerQueryAll(s, pkc, ? Result.assertUnwrapAny<T.UserId>(uidc));
      await retailerQueryAll(s, pkd, ? Result.assertUnwrapAny<T.UserId>(uidd));
      await retailerQueryAll(s, pke, ? Result.assertUnwrapAny<T.UserId>(uide));

      print "\nQuery counts\n----------------\n";
      let counts = await s.getCounts();

      printEntityCount("Retailer join", counts.retailer_join_count);
      printEntityCount("Retailer query", counts.retailer_query_count);
      printLabeledCost("Retailer query", counts.retailer_query_cost);

    })
  };
};


func retailerQueryAll(server:A.Server, pk:Text, r:?T.UserId) : async () {

  print "\nRetailer ";
  let retailerId: T.UserId = Option.unwrap<T.UserId>(r);
  printInt retailerId;
  print " sends `retailerQueryAll`\n";
  print "------------------------------------\n";

  print "\n## Query begin:\n";
  let res = Result.assertUnwrapAny<T.QueryAllResults>(
    await server.retailerQueryAll(pk, retailerId, null, null)
  );
  print "\n## Query end.";

  print "\n## Query results (";
  printInt (res.len());
  print ")\n";
  for (info in res.vals()) {
    print "- ";
    print (debug_show info);
    print "\n";
  }
};

func debugDumpAll(server:A.Server) : async () {

  print "\nTruck type info\n----------------\n";
  for ( info in ((await server.allTruckTypeInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nRegion info\n----------------\n";
  for ( info in ((await server.allRegionInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nProduce info\n----------------\n";
  for ( info in ((await server.allProduceInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nProducer info\n----------------\n";
  for ( info in ((await server.allProducerInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nTransporter info\n----------------\n";
  for ( info in ((await server.allTransporterInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nRetailer info\n----------------\n";
  for ( info in ((await server.allRetailerInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nInventory info\n----------------\n";
  for ( info in ((await server.allInventoryInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };

  print "\nRoute info\n----------------\n";
  for ( info in ((await server.allRouteInfo()).vals()) ) {
    print "- ";
    print (debug_show info);
    print "\n";
  };
};

let test = Test();
test.go()