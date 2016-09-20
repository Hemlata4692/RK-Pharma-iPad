//
//  Webservice.m
//  RKPharma
//
//  Created by Ranosys Technologies on 4/25/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "WebService.h"
#import "JSON.h"
#import "Internet.h"
@implementation WebService


-(NSString*)doLogin:(id)login
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"Login"];
        
        responseData=[NSMutableData data];
        
        NSString *username_string = [login valueForKey:@"username"];
        NSString *password_string = [login valueForKey:@"password"];
           
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\"}",username_string,password_string];
        
       //NSString *jsonRequest = @"{\"Username\":\"nikhil\",\"Password\":\"password\"}";
        NSLog(@"Request: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
    
}

-(NSString*)GetDailyPlanWeb:(id)Request latitude:(NSString*)latitude longitude:(NSString*)longitude isLatLong:(NSString*)isLatLong
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetDailyPlan"];
    
//        NSDate *currentdateall = [NSDate date];
//        NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
//        [formatter_date setDateFormat:@"dd-MMM-yyyy "];
//        NSString *date_str = [formatter_date stringFromDate:currentdateall];
        
        NSString *date_str = [Request valueForKey:@"plan_date"];
    
        //To Get Daily Plan from Webservice
        //NSString *jsonRequest_dailyplan = [NSString stringWithFormat:@"{\"Date\":\"11-May-2013\",\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        NSString *jsonRequest_dailyplan = [NSString stringWithFormat:@"{\"Date\":\"%@\",\"UserId\":\"%@\",\"Latitude\":\"%@\",\"Longitude\":\"%@\",\"IsLatLong\":\"%@\"}",date_str,[defaults objectForKey:@"UserId"],latitude, longitude, isLatLong];
    
        NSLog(@"Request Daily Plan: %@", jsonRequest_dailyplan);
        NSURL *url_dailyplan = [NSURL URLWithString:WebserviceUrl];
        NSData *postData_dailyplan = [jsonRequest_dailyplan dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength_dailyplan = [NSString stringWithFormat:@"%d", (int)[postData_dailyplan length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url_dailyplan];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength_dailyplan forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData_dailyplan];
        NSURLResponse *dailyplan_response = nil;
        NSError *dailyplan_error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&dailyplan_response error:&dailyplan_error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
        return responseString;//return webservice response
    }
}


-(NSString*)GetAnnouncement
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetAnnouncements"];
        
        NSString *jsonRequest_announcement = [NSString stringWithFormat:@"{\"IsDashboard\":\"%d\",\"UserId\":\"%@\"}",1,[defaults objectForKey:@"UserId"]];
        //NSString *jsonRequest_announcement = @"{\"IsDashboard\":\"True\",\"UserId\":\"8ff72528-684e-44d8-a4b8-7277f83db3db\"}";
        NSLog(@"Request Announcement: %@", jsonRequest_announcement);
        NSURL *url_announcement = [NSURL URLWithString:WebserviceUrl];
        NSData *postData_announcement = [jsonRequest_announcement dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength_announcement = [NSString stringWithFormat:@"%d", [postData_announcement length]];
        
        NSMutableURLRequest *request_announcement = [[NSMutableURLRequest alloc] init];
        [request_announcement setURL:url_announcement];
        [request_announcement setHTTPMethod:@"POST"];
        [request_announcement setValue:postLength_announcement forHTTPHeaderField:@"Content-Length"];
        [request_announcement setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request_announcement setHTTPBody:postData_announcement];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request_announcement returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetClinicList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetClinics"];
        
        NSString *lastvisited_string = [Request valueForKey:@"lastvisited"];
        NSString *clinic_string = [Request valueForKey:@"clinic_name"];
        NSString *phone_string = [Request valueForKey:@"phone_number"];
        //NSString *pincode_string = [Request valueForKey:@"pin_code"];
        NSString *location_string = [Request valueForKey:@"location"];
        //NSString *doctor_string = [Request valueForKey:@"doctor_name"];
        NSString *specializationid_string = [Request valueForKey:@"specialization_id"];
        NSString *offset_string = [Request valueForKey:@"offset"];
        int locationint = [location_string intValue];
        int specializationint = [specializationid_string intValue];
        int Offsetint = [offset_string intValue];
        NSLog(@" Offset Integer : %d",Offsetint);
        NSLog(@" Location String : %@",location_string);
        //To Get Clinic List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"Offset\":\"%d\",\"UserId\":\"%@\",\"Contact\":\"%@\",\"LocationId\":\"%d\",\"ClinicName\":\"%@\",\"SpecializationId\":\"%d\",\"Visited\":\"%@\",\"IsSearch\":\"%@\"}",Offsetint,[defaults objectForKey:@"UserId"],phone_string,locationint,clinic_string,specializationint,lastvisited_string,[Request valueForKey:@"isSearch"]];
        
        NSLog(@"Json Request Clinic List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetArea
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetLocations"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Json Request Location List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }

}

-(NSString*)getOrderData:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetOrder"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"OrderId\":\"%@\"}",[Request valueForKey:@"order_id"]];
        
        NSLog(@"order Json Request Location List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"oirder respon %@",responseString);
        return responseString;//return webservice response
    }
    
    
}

-(NSString*)GetOrderList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetOrders"];
        
        NSString *dateto_string = [Request valueForKey:@"dateto_string"];
        NSString *datefrom_string = [Request valueForKey:@"datefrom_string"];
        
        NSString *location_string = [Request valueForKey:@"location_id"];
        int locationint = [location_string intValue];
        
        NSString *product_string = [Request valueForKey:@"product_name"];
        int productint = [product_string intValue];
        
        NSString *specialization_string = [Request valueForKey:@"specialization_id"];
        int specializationint = [specialization_string intValue];
        
        NSString *offset_string = [Request valueForKey:@"offset"];
        int Offsetint = [offset_string intValue];
        
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"LocationId\":\"%d\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\",\"Specialization\":\"%d\",\"ProductId\":\"%d\",\"Offset\":\"%d\"}",[defaults objectForKey:@"UserId"],locationint,datefrom_string,dateto_string,specializationint,productint,Offsetint];
        
        NSLog(@"Json Request Order List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetOrdersTotal:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetOrdersTotal"];
        
        NSString *dateto_string = [Request valueForKey:@"dateto"];
        NSString *datefrom_string = [Request valueForKey:@"datefrom"];
        
        NSString *location_string = [Request valueForKey:@"locationid"];
        int locationint = [location_string intValue];
        
        NSString *product_string = [Request valueForKey:@"productid"];
        int productint = [product_string intValue];
        
        NSString *specialization_string = [Request valueForKey:@"specialization"];
        int specializationint = [specialization_string intValue];
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"LocationId\":\"%d\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\",\"Specialization\":\"%d\",\"ProductId\":\"%d\"}",[defaults objectForKey:@"UserId"],locationint,datefrom_string,dateto_string,specializationint,productint];
        
        //NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"cae9bbc2-3b5a-4f1b-9a97-f379728c26d8\",\"LocationId\":\"%d\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\",\"Specialization\":\"%d\",\"ProductId\":\"%d\"}",locationint,datefrom_string,dateto_string,specializationint,productint];
        
        NSLog(@"Json Request Order Total: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}



-(NSString*)RepeatDeliveryTerm:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"RepeatDeliveryTerm"];
        
        NSString *clinicId = [Request valueForKey:@"clinic_id"];
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"ClinicId\":\"%@\"}",clinicId];
        
        NSLog(@"Json Request Order Total: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetProductInfo:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetProductInfo"];
        
        NSString *productId = [Request valueForKey:@"product_id"];
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"ProductId\":\"%@\"}",productId];
        
        NSLog(@"Json Request Order Total: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}
-(NSString*)RepeatProductInfo:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"RepeatProduct"];
        
        NSString *productId = [Request valueForKey:@"product_id"];
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"ProductId\":\"%@\",\"ClinicId\":\"%@\"}",productId,[Request valueForKey:@"clinic_id"]];
        
        NSLog(@"Json Request Order Total: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetReminder
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetReminder"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Json Request Order List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetClinicNameList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetClinicPlanList"];
        
        NSString *location_string = [Request valueForKey:@"location"];
        int locationint = [location_string intValue];
        
        NSString * lastVisited = [Request valueForKey:@"LastVisited"];
        if ([lastVisited isEqualToString:NULL] || [lastVisited isEqualToString:nil] || [lastVisited isEqualToString:@""] || lastVisited ==nil|| lastVisited==NULL)
        {
            lastVisited = [NSString stringWithFormat:@"%d",0];
            NSLog(@"lastvisited is zero");
        }
        NSLog(@" Last Visited : %@",lastVisited);
         NSLog(@" Location String : %d",locationint);
         NSLog(@" User Id : %@",[defaults objectForKey:@"UserId"]);
        
        //To Get Clinic List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"LocationId\":\"%d\",\"LastVisited\":\"%@\"}",[defaults objectForKey:@"UserId"],locationint,lastVisited];
        
        NSLog(@"Json Request Clinic Name List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetAllClinicList
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetAllClinicList"];
        
        //        NSString *location_string = [Request valueForKey:@"location"];
        //        int locationint = [location_string intValue];
        //
        //        NSString * lastVisited = [Request valueForKey:@"LastVisited"];
        //        if ([lastVisited isEqualToString:NULL] || [lastVisited isEqualToString:nil] || [lastVisited isEqualToString:@""] || lastVisited ==nil|| lastVisited==NULL)
        //        {
        //            lastVisited = [NSString stringWithFormat:@"%d",0];
        //            NSLog(@"lastvisited is zero");
        //        }
        //        NSLog(@" Last Visited : %@",lastVisited);
        //        NSLog(@" Location String : %d",locationint);
        //        NSLog(@" User Id : %@",[defaults objectForKey:@"UserId"]);
        
        //To Get Clinic List from Webservice
        
        //        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"LocationId\":\"%d\",\"LastVisited\":\"%@\"}",[defaults objectForKey:@"UserId"],locationint,lastVisited];
        
//                NSLog(@"Json Request Clinic Name List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        //        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        //        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        //        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)AddReminder:Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"AddReminder"];
        
        NSString *clinic_string = [Request valueForKey:@"clinic_string"];
        NSString *reminder = [Request valueForKey:@"remarks_string"];
        NSString *current_datetime = [Request valueForKey:@"current_datetime"];
        
        int clinicint = [clinic_string intValue];
        //To Get Clinic List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"ClinicId\":\"%d\",\"Remarks\":\"%@\",\"AddedOn\":\"%@\"}",[defaults objectForKey:@"UserId"],clinicint,reminder,current_datetime];
        
        NSLog(@"Json Add Reminder Request: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)AddOrder:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"AddOrder"];
        
         NSString *new_orderstatus = @"";
        if([[Request valueForKey:@"OrderStatus"] isEqualToString:@"Delivered"])
        {
        
       
        if([[Request valueForKey:@"DeliveryDate"] length] > 0)
        {
            NSDate *currentdate = [NSDate date];
            NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
            [formatter_date setDateFormat:@"dd-MMM-yyyy"];
            NSString *date_str = [formatter_date stringFromDate:currentdate];
            NSLog(@" CURRENT DATe %@",date_str);
            NSDate *date1=[formatter_date dateFromString:date_str];
            
            NSDate *deliverydate=[formatter_date dateFromString:[NSString stringWithFormat:@"%@",[Request valueForKey:@"DeliveryDate"]]];
            
            if ([deliverydate compare: date1] == NSOrderedSame)
            {
                NSLog(@" DE DAte Processing");
                new_orderstatus = @"Processing";
            }
            else if([deliverydate compare: date1] == NSOrderedAscending)
            {
                NSLog(@" DE DAte Delivered");
                new_orderstatus = @"Delivered";
            }
            else
            {
                NSLog(@"De DAte Else Processing");
                new_orderstatus = @"Processing";
            }
        }
        else
        {
             new_orderstatus = @"Processing";
        }
        }
        else
        {
            new_orderstatus = @"Processing";
        }
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"ClinicId\":\"%@\",\"StaffId\":\"%@\",\"OrderDate\":\"%@\",\"OrderSource\":\"%@\",\"OrderStatus\":\"%@\",\"Comments\":\"%@\",\"DeliveryDate\":\"%@\",\"DeliveryNote\":\"%@\",\"DeliveryTerm\":\"%@\",\"OrderType\":\"%@\",\"PrefDeliveryTime\":\"%@\",\"InvoiceReturned\":\"%d\",\"PaymentReceived\":\"%d\",\"BuyerOrderDate\":\"%@\",\"BuyerOrderNo\":\"%@\",\"ProductOrder\":\"%@\",\"iPadRemark\":\"%@\"}",[Request valueForKey:@"ClinicId"],[Request valueForKey:@"StaffId"],[Request valueForKey:@"OrderDate"],[Request valueForKey:@"OrderSource"],new_orderstatus,[Request valueForKey:@"Comments"],[Request valueForKey:@"DeliveryDate"],[Request valueForKey:@"DeliveryNote"],[Request valueForKey:@"DeliveryTerm"],[Request valueForKey:@"OrderType"],[Request valueForKey:@"PrefDeliveryTime"],[[Request valueForKey:@"InvoiceReturned"]intValue],[[Request valueForKey:@"PaymentReceived"]intValue],[Request valueForKey:@"BuyerOrderDate"],[Request valueForKey:@"BuyerOrderNo"],[Request valueForKey:@"ProductOrder"],[Request valueForKey:@"iPadRemark"]];
        
        NSLog(@"Json Request Add Order: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response %@",responseString);
        return responseString;//return webservice response
    }
}

-(NSString*)EditOrder:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"EditOrder"];
        
        NSLog(@" ORDER STATUS %@",[Request valueForKey:@"OrderStatus"]);
        NSString *new_orderstatus = @"";
        if([[Request valueForKey:@"OrderStatus"] isEqualToString:@"Delivered"])
        {
            
            
            if([[Request valueForKey:@"DeliveryDate"] length] > 0)
            {
                NSDate *currentdate = [NSDate date];
                NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
                [formatter_date setDateFormat:@"dd-MMM-yyyy"];
                NSString *date_str = [formatter_date stringFromDate:currentdate];
                NSLog(@" CURRENT DATe %@",date_str);
                NSDate *date1=[formatter_date dateFromString:date_str];
                
                NSDate *deliverydate=[formatter_date dateFromString:[NSString stringWithFormat:@"%@",[Request valueForKey:@"DeliveryDate"]]];
                
                if ([deliverydate compare: date1] == NSOrderedSame)
                {
                    NSLog(@" DE DAte Processing");
                    new_orderstatus = @"Processing";
                }
                else if([deliverydate compare: date1] == NSOrderedAscending)
                {
                    NSLog(@" DE DAte Delivered");
                    new_orderstatus = @"Delivered";
                }
                else
                {
                    NSLog(@"De DAte Else Processing");
                    new_orderstatus = @"Processing";
                }
            }
            else
            {
                new_orderstatus = @"Processing";
            }
        }
        else
        {
            new_orderstatus = @"Processing";
        }

        
        
        
//        NSString *jsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%@\",\"ClinicId\":\"%@\",\"StaffId\":\"%@\",\"OrderDate\":\"%@\",\"OrderSource\":\"%@\",\"OrderStatus\":\"%@\",\"Comments\":\"%@\",\"DeliveryDate\":\"%@\",\"DeliveryNote\":\"%@\",\"DeliveryTerm\":\"%@\",\"OrderType\":\"%@\",\"PrefDeliveryTime\":\"%@\",\"InvoiceReturned\":\"%d\",\"PaymentReceived\":\"%d\",\"BuyerOrderDate\":\"%@\",\"BuyerOrderNo\":\"%@\",\"UpdatedProductOrder\":\"%@\",\"PrevUpdatedProductOrder\":\"%@\",\"OldOrderType\":\"%@\",\"iPadRemark\":\"%@\"}",[defaults objectForKey:@"OrderId"],[Request valueForKey:@"ClinicId"],[Request valueForKey:@"StaffId"],[Request valueForKey:@"OrderDate"],[Request valueForKey:@"OrderSource"],new_orderstatus,[Request valueForKey:@"Comments"],[Request valueForKey:@"DeliveryDate"],[Request valueForKey:@"DeliveryNote"],[Request valueForKey:@"DeliveryTerm"],[Request valueForKey:@"OrderType"],[Request valueForKey:@"PrefDeliveryTime"],[[Request valueForKey:@"InvoiceReturned"]intValue],[[Request valueForKey:@"PaymentReceived"]intValue],[Request valueForKey:@"BuyerOrderDate"],[Request valueForKey:@"BuyerOrderNo"],[Request valueForKey:@"ProductOrder"],[Request valueForKey:@"ProductOrder1"],[Request valueForKey:@"OldOrderType"],[Request valueForKey:@"iPadRemark"]];
        
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%@\",\"ClinicId\":\"%@\",\"StaffId\":\"%@\",\"OrderDate\":\"%@\",\"OrderSource\":\"%@\",\"OrderStatus\":\"%@\",\"Comments\":\"%@\",\"DeliveryDate\":\"%@\",\"DeliveryNote\":\"%@\",\"DeliveryTerm\":\"%@\",\"OrderType\":\"%@\",\"PrefDeliveryTime\":\"%@\",\"InvoiceReturned\":\"%d\",\"PaymentReceived\":\"%d\",\"BuyerOrderDate\":\"%@\",\"BuyerOrderNo\":\"%@\",\"UpdatedProductOrder\":\"%@\",\"PrevUpdatedProductOrder\":\"%@\",\"iPadRemark\":\"%@\"}",[defaults objectForKey:@"OrderId"],[Request valueForKey:@"ClinicId"],[Request valueForKey:@"StaffId"],[Request valueForKey:@"OrderDate"],[Request valueForKey:@"OrderSource"],new_orderstatus,[Request valueForKey:@"Comments"],[Request valueForKey:@"DeliveryDate"],[Request valueForKey:@"DeliveryNote"],[Request valueForKey:@"DeliveryTerm"],[Request valueForKey:@"OrderType"],[Request valueForKey:@"PrefDeliveryTime"],[[Request valueForKey:@"InvoiceReturned"]intValue],[[Request valueForKey:@"PaymentReceived"]intValue],[Request valueForKey:@"BuyerOrderDate"],[Request valueForKey:@"BuyerOrderNo"],[Request valueForKey:@"ProductOrder"],[Request valueForKey:@"ProductOrder1"],[Request valueForKey:@"iPadRemark"]];

        
        
        
        NSLog(@"Json Request Edit Order %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response %@",responseString);
        return responseString;//return webservice response
    }
}


-(NSString*)GetProductList
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetProductsList"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"ClinicId\":\"0\"}",[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Json Request Product List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

//Added by rohit modi
- (NSString*)GetProductListUsingClinicId:(NSString*)clinicId
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetProductsList"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"ClinicId\":\"%@\"}",[defaults objectForKey:@"UserId"],clinicId];
        
        NSLog(@"Json Request Product List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}
//end

-(NSString*)GetAllProductList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetProducts"];
        
        NSString *offset_string = [Request valueForKey:@"offset"];
        int Offsetint = [offset_string intValue];
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"Offset\":\"%d\"}",[defaults objectForKey:@"UserId"],Offsetint];
        
        NSLog(@"Json Request Product List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetNewProductsLists:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetOrders"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"LocationId\":\"%@\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\",\"Specialization\":\"%@\",\"ProductId\":\"%@\",\"Offset\":\"%d\"}",[defaults objectForKey:@"UserId"],[Request valueForKey:@"locationid"],[Request valueForKey:@"datefrom"],[Request valueForKey:@"dateto"],[Request valueForKey:@"specialization"],[Request valueForKey:@"productid"],[[Request valueForKey:@"offset"] intValue]];
        
        //NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"cae9bbc2-3b5a-4f1b-9a97-f379728c26d8\",\"LocationId\":\"%@\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\",\"Specialization\":\"%@\",\"ProductId\":\"%@\",\"Offset\":\"%d\"}",[Request valueForKey:@"locationid"],[Request valueForKey:@"datefrom"],[Request valueForKey:@"dateto"],[Request valueForKey:@"specialization"],[Request valueForKey:@"productid"],[[Request valueForKey:@"offset"] intValue]];
        
        NSLog(@"Json Request Product List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response %@",responseString);
        return responseString;//return webservice response
    }
}

-(NSString*)GetClinicDetail:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetClinicDetail"];
        
        NSString *clinicid_string = [Request valueForKey:@"clinic_id"];
        int clinicidint = [clinicid_string intValue];
        //To Get Clinic List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"ClinicId\":\"%d\"}",[defaults objectForKey:@"UserId"],clinicidint];
        
        NSLog(@"Json Request Clinic Detail: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }

}

-(NSString*)GetAllAnnouncement
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetAnnouncements"];
        
        // To Get Latest Announcement from Webservice
        
        NSString *jsonRequest_announcement = [NSString stringWithFormat:@"{\"IsDashboard\":\"%d\",\"UserId\":\"%@\"}",0,[defaults objectForKey:@"UserId"]];
        //NSString *jsonRequest_announcement = @"{\"IsDashboard\":\"True\",\"UserId\":\"8ff72528-684e-44d8-a4b8-7277f83db3db\"}";
        NSLog(@"Request Announcement: %@", jsonRequest_announcement);
        NSURL *url_announcement = [NSURL URLWithString:WebserviceUrl];
        NSData *postData_announcement = [jsonRequest_announcement dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength_announcement = [NSString stringWithFormat:@"%d", [postData_announcement length]];
        
        NSMutableURLRequest *request_announcement = [[NSMutableURLRequest alloc] init];
        [request_announcement setURL:url_announcement];
        [request_announcement setHTTPMethod:@"POST"];
        [request_announcement setValue:postLength_announcement forHTTPHeaderField:@"Content-Length"];
        [request_announcement setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request_announcement setHTTPBody:postData_announcement];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request_announcement returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)DeleteDailyPlan:(id)Planid
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"DeletePlan"];
        
        NSString *planid_string = [Planid valueForKey:@"plan_id"];
        int planidint = [planid_string intValue];
        
        //To Delete Daily Plan from Webservice
        
        NSString *jsonRequest_dailyplan = [NSString stringWithFormat:@"{\"PlanId\":\"%d\",\"UserId\":\"%@\"}",planidint,[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Request Delete Daily Plan: %@", jsonRequest_dailyplan);
        NSURL *url_dailyplan = [NSURL URLWithString:WebserviceUrl];
        NSData *postData_dailyplan = [jsonRequest_dailyplan dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength_dailyplan = [NSString stringWithFormat:@"%d", [postData_dailyplan length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url_dailyplan];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength_dailyplan forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData_dailyplan];
        NSURLResponse *dailyplan_response = nil;
        NSError *dailyplan_error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&dailyplan_response error:&dailyplan_error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)AddClinics:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"AddPlan"];
        
        [defaults objectForKey:@"Unplanned"];
        
        //NSString *Unplanned_string = [defaults objectForKey:@"Unplanned"];
        NSString *Unplanned_string = [Request valueForKey:@"unplanned"];
        int Unplannedint = [Unplanned_string intValue];
        
        NSLog(@"Unplanned Int %d",Unplannedint);
        
        NSString *plandate_string = [Request valueForKey:@"plan_date"];
        NSString *clinicid_string = [Request valueForKey:@"clinic_id"];
        NSString *KIVclinicid_string = [Request valueForKey:@"KIVclinic_id"];
        
        NSLog(@"clinic ISSSSS %@",clinicid_string);
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"ClinicList\":\"%@\",\"Date\":\"%@\",\"UnPlanned\":\"%d\",\"KIVClinicsNotSelected\":\"%@\"}",[defaults objectForKey:@"UserId"],clinicid_string,plandate_string,Unplannedint,KIVclinicid_string];
        
        NSLog(@"Json Request Add Clinic: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}



-(NSString*)GetDailyPlanSummarylist:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetDailyPlanReport"];
        
        //NSString *plan_date = [Request valueForKey:@"plan_date"];
        NSString *start_date = [Request valueForKey:@"StartDate"];
        NSString *end_date = [Request valueForKey:@"EndDate"];
        
        //To Get Daily Plan Summary Report List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"StartDate\":\"%@\",\"EndDate\":\"%@\",\"UserId\":\"%@\"}",start_date,end_date,[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Json Request Plan Summary List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetCallCardlist:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetCallCard"];
        
        NSString *clinicid_string = [Request valueForKey:@"clinic_id"];
        int clinicidint = [clinicid_string intValue];
        
        NSString *issuedbycompany_string = [Request valueForKey:@"WebSummary"];
        int issuedbycompanyint = [issuedbycompany_string intValue];
        
        NSString *divisionid_string = [Request valueForKey:@"divisionid"];
        int divisionid = [divisionid_string intValue];
        //int clinicidint  = 76;
        //int divisionidint  = 4;
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"ClinicId\":\"%d\",\"UserId\":\"%@\",\"WebSummary\":\"%d\",\"DivisionId\":\"%d\"}",clinicidint,[defaults objectForKey:@"UserId"],issuedbycompanyint,divisionid];
        
        NSLog(@"Json Request Call Card List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetDailyReport:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetDailyReport"];
        
        NSString *plan_date = [Request valueForKey:@"plan_date"];
        
        //To Get Daily Plan Summary Report List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"PlanDate\":\"%@\",\"UserId\":\"%@\"}",plan_date,[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Json Request Plan Summary List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetSamples:(id)Planid
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"Getsamples"];
        
        NSString *planid_string = [Planid valueForKey:@"plan_id"];
        int planidint = [planid_string intValue];
        
        NSString *month_string = [Planid valueForKey:@"month"];
        int monthint = [month_string intValue];
        
        NSString *year_string = [Planid valueForKey:@"year"];
        int yearint = [year_string intValue];
        
        //To Get Order List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"PlanId\":\"%d\",\"Month\":\"%d\",\"Year\":\"%d\"}",[defaults objectForKey:@"UserId"],planidint,monthint,yearint];
        
        NSLog(@"Json Request Sample List: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetGeoCode:(id)Pincode
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSString *url = @"https://maps.googleapis.com/maps/api/geocode/json";
        //NSString *WebserviceUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",@"574623"];
        
        NSString *WebserviceUrl = @"";
        
        WebserviceUrl=[WebserviceUrl stringByAppendingFormat:@"address=574623&sensor=true"];
        
        //NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [WebserviceUrl dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}



-(NSString*)AddCallSummary:(id)Summary
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"AddMeetingSummary"];
        
        NSString *planid_string = [Summary valueForKey:@"plan_id"];
        int planidint = [planid_string intValue];
        NSString *issuequantity = [Summary valueForKey:@"issue_quantity"];
        NSString *orderinfo = [Summary valueForKey:@"orderinfo"];
        NSString *remarks = [Summary valueForKey:@"remarks"];
        NSString *samplechitno = [Summary valueForKey:@"samplechitno"];
        NSString *postcalldate = [Summary valueForKey:@"postcalldate"];
        NSString *calltype = [Summary valueForKey:@"calltype"];
        
        NSString *kivproducts = [Summary valueForKey:@"kiv_products"];
        
        NSString *assistant_string = [Summary valueForKey:@"assistant_selected"];
        int assistantint = [assistant_string intValue];
        
        
        //To Get Order List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"PlanId\":\"%d\",\"OrderInfo\":\"%@\",\"Remarks\":\"%@\",\"ChitNo\":\"%@\",\"SamplesList\":\"%@\",\"CallType\":\"%@\",\"CallDate\":\"%@\",\"CallAssistant\":\"%d\",\"KIV_Products\":\"%@\"}",[defaults objectForKey:@"UserId"],planidint,orderinfo,remarks,samplechitno,issuequantity,calltype,postcalldate,assistantint,kivproducts];
        
        NSLog(@"Json Request Add Summmary : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetMeetingSummary:(id)Summary
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetMeetingSummary"];
        
        NSString *plandate_string = [Summary valueForKey:@"plan_date"];
        
        NSString *isvisited_string = [Summary valueForKey:@"IsVisited"];
        int IsVisitedint = [isvisited_string intValue];
        
        //To Get Order List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"SummaryDate\":\"%@\",\"IsVisited\":\"%d\"}",[defaults objectForKey:@"UserId"],plandate_string,IsVisitedint];
        
        NSLog(@"Json Request Get Summmary : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetMeetingSummaryDetails:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetMeetingSummaryDetails"];
        
         NSLog(@" Summary Key Before");
        NSString *summaryid_string = [Request valueForKey:@"summaryId"];
        int SummaryIdint = [summaryid_string intValue];
        
        //To Get Order List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"SummaryId\":\"%d\"}",[defaults objectForKey:@"UserId"],SummaryIdint];
        
        NSLog(@"Json Request Get Summmary Details: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)EditMeetingSummary:(id)Summary
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"EditMeetingSummary"];
        
        NSString *planid_string = [Summary valueForKey:@"plan_id"];
        int planidint = [planid_string intValue];
        NSString *issuequantity = [Summary valueForKey:@"issue_quantity"];
        NSString *orderinfo = [Summary valueForKey:@"orderinfo"];
        NSString *remarks = [Summary valueForKey:@"remarks"];
        NSString *samplechitno = [Summary valueForKey:@"samplechitno"];
        NSString *postcalldate = [Summary valueForKey:@"postcalldate"];
        NSString *calltype = [Summary valueForKey:@"calltype"];
        NSString *summaryid_string = [Summary valueForKey:@"summaryId"];
        int summaryidint = [summaryid_string intValue];
        
        NSString *assistant_string = [Summary valueForKey:@"assistant_selected"];
        int assistantint = [assistant_string intValue];
        
        NSString *kivproducts = [Summary valueForKey:@"kiv_products"];
        
        //To Get Order List from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"PlanId\":\"%d\",\"OrderInfo\":\"%@\",\"Remarks\":\"%@\",\"ChitNo\":\"%@\",\"SamplesList\":\"%@\",\"CallType\":\"%@\",\"CallDate\":\"%@\",\"CallAssistant\":\"%d\",\"SummaryId\":\"%d\",\"KIV_Products\":\"%@\"}",[defaults objectForKey:@"UserId"],planidint,orderinfo,remarks,samplechitno,issuequantity,calltype,postcalldate,assistantint,summaryidint,kivproducts];
        
        NSLog(@"Json Request Edit Summmary : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)DeleteReminder:(id)ReminderId
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"DeleteReminder"];
        
        NSString *reminderid_string = [ReminderId valueForKey:@"reminder_id"];
        int reminderidint = [reminderid_string intValue];
        
        //To Delete Daily Plan from Webservice
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"AlertId\":\"%d\",\"UserId\":\"%@\"}",reminderidint,[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Request Delete Reminder : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetSingaporeTime
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetSingaporeTime"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        
        NSLog(@"Request SingaporeTime : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response

    }
}

-(NSString*)GetSpecialization
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetSpecialization"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        //NSString *jsonRequest_announcement = @"{\"IsDashboard\":\"True\",\"UserId\":\"8ff72528-684e-44d8-a4b8-7277f83db3db\"}";
        NSLog(@"Request Specialization: %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)SendUserLocation:(id)Location
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else 
    {
        // To Get Latest Announcement from Webservice
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"LocationTracking"];
        
        NSString *latitude_string = [Location valueForKey:@"latitude"];
        NSString *longitude_string = [Location valueForKey:@"longitude"];
        
        NSString *jsonRequest_announcement = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"Latitude\":\"%@\",\"Longitude\":\"%@\"}",[defaults objectForKey:@"UserId"],latitude_string,longitude_string];
        //NSString *jsonRequest_announcement = @"{\"IsDashboard\":\"True\",\"UserId\":\"8ff72528-684e-44d8-a4b8-7277f83db3db\"}";
        NSLog(@"Request Location Tracking: %@", jsonRequest_announcement);
        NSURL *url_announcement = [NSURL URLWithString:WebserviceUrl];
        NSData *postData_announcement = [jsonRequest_announcement dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength_announcement = [NSString stringWithFormat:@"%d", [postData_announcement length]];
        
        NSMutableURLRequest *request_announcement = [[NSMutableURLRequest alloc] init];
        [request_announcement setURL:url_announcement];
        [request_announcement setHTTPMethod:@"POST"];
        [request_announcement setValue:postLength_announcement forHTTPHeaderField:@"Content-Length"];
        [request_announcement setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request_announcement setHTTPBody:postData_announcement];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request_announcement returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Response is%@", responseString);
        return responseString;//return webservice response
    }
}

-(NSString*)GetProductsKIV:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetProductsKIV"];
        
        NSString *dateto_string = [Request valueForKey:@"dateto_string"];
        NSString *datefrom_string = [Request valueForKey:@"datefrom_string"];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"StartDate\":\"%@\",\"EndDate\":\"%@\",\"ProductId\":\"%@\",\"LocationId\":\"%@\"}",[defaults objectForKey:@"UserId"],datefrom_string,dateto_string,[Request valueForKey:@"ProductId"],[Request valueForKey:@"LocationId"]];
        NSLog(@"json %@",jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response  %@",responseString);
        return responseString;//return webservice response
    }
    
}

-(NSString*)GetDivisionList
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetDivisionList"];
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\"}",[defaults objectForKey:@"UserId"]];
        NSLog(@"Json Division List Request %@",jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response  %@",responseString);
        return responseString;//return webservice response
    }
    
}

-(NSString*)GetSampleRequestList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
//        NSString *WebserviceUrl = @"http://rkpharma.com/rkpservice/rkservice.svc/";
//        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"StartDate\":\"%@\",\"EndDate\":\"%@\"}",@"643ab16c-24db-41ad-92a2-60bb3143ff03",datefrom_string,dateto_string];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetRequestedSample"];
        NSLog(@" Webservice URL : %@",WebserviceUrl);
        NSString *dateto_string = [Request valueForKey:@"dateto_string"];
        NSString *datefrom_string = [Request valueForKey:@"datefrom_string"];
        
        
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"StartDate\":\"%@\",\"EndDate\":\"%@\"}",[defaults objectForKey:@"UserId"],datefrom_string,dateto_string];
        
        NSLog(@"Json Sample Request : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetSampleReturnList:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetReturnedSamples"];
        NSLog(@" Webservice URL : %@",WebserviceUrl);
        NSString *dateto_string = [Request valueForKey:@"dateto_string"];
        NSString *datefrom_string = [Request valueForKey:@"datefrom_string"];
        
        
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"DateFrom\":\"%@\",\"DateTo\":\"%@\"}",[defaults objectForKey:@"UserId"],datefrom_string,dateto_string];
        
        NSLog(@"Json Sample Return : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

-(NSString*)GetSampleDetails:(id)Request
{
    Internet *internet=[[Internet alloc] init];
    if([internet start])
    {
        return @"";
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *WebserviceUrl = [defaults objectForKey:@"main_url"];
        WebserviceUrl = [WebserviceUrl stringByAppendingString:@"GetSampleDetail"];
        NSLog(@" Webservice URL : %@",WebserviceUrl);
        
        NSString *sampleid_string = [Request valueForKey:@"sampleid"];
        int sampleidint = [sampleid_string intValue];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"SampleId\":\"%d\"}",[defaults objectForKey:@"UserId"],sampleidint];
        
        
        NSLog(@"Json  Sample Return Details : %@", jsonRequest);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        return responseString;//return webservice response
    }
}

- (NSString *)call_Webservice:(id)arguments
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start]) {
        return @"";
    }
    responseData=[NSMutableData data];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonRequest =[arguments valueForKey:@"json"];
    NSLog(@"json request %@",jsonRequest);
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"main_url"],[arguments valueForKey:@"method_name"]];
    NSLog(@"url %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *postData = [jsonRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response = nil;
    NSError *error = nil;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"response %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    BOOL isValid = [NSJSONSerialization isValidJSONObject:jsonObj];
    if (isValid) {
        return [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    else {
        return @"jsonfailed";
    }
    
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
