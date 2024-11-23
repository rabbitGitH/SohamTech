global class RequestWrapper {
       // public string External_Id {get; set;}
        public string ContactId {get; set;}
        public string AccountId {get; set;}
        public string Status {get; set;}
        public string Origin {get; set;}
        public string Priority {get; set;}
        public string Type {get; set;}
        public string Reason {get; set;}
        public string Subject {get; set;}
        public string Description {get; set;}
        public string Comments {get; set;}
        
        public RequestWrapper( string ContactId,string AccountId,string Status,string Origin,string Priority,string Type,string Reason,string Subject,string Description,string Comments){
       //     this.External_Id = External_Id;
            this.ContactId = ContactId;
            this.AccountId = AccountId;
            this.Status = Status;
            this.Origin = Origin;
            this.Priority = Priority;
            this.Type = Type;
            this.Reason = Reason;
            this.Subject = Subject;
            this.Description = Description;
            this.Comments = Comments;
        }
    }